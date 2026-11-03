import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick.Effects

// Workspace overview, after end-4: every workspace as a tile with live
// previews of its windows, laid out where they really are.
// Click a window to focus it · drag it onto another tile to move it ·
// middle-click to close it · click a tile to go there ·
// arrows + Enter or 1-9/0 to pick a workspace · Esc closes.
PanelWindow {
  id: overview
  visible: false
  color: "transparent"
  objectName: "Overview"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell:overview"
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

  anchors { top: true; left: true; right: true; bottom: true }

  property alias timer: closeTimer

  readonly property int columns: 5
  readonly property int workspaceCount: 10
  readonly property int gap: 12
  // Tile size relative to the monitor; shrinks if five don't fit.
  readonly property real ratio: Math.min(0.17, (width * 0.9 - (columns - 1) * gap) / columns / Math.max(1, width))
  readonly property real tileW: width * ratio
  readonly property real tileH: height * ratio

  readonly property var monitor: Hyprland.monitorFor(screen)
  readonly property int activeWs: monitor?.activeWorkspace?.id ?? Hyprland.focusedWorkspace?.id ?? 1
  property int selectedWs: 1
  property bool _open: false

  // Drag state: the window being dragged and the workspace under the cursor.
  property var dragTop: null
  property int dropWs: -1

  readonly property color _fg:     Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _dim:    Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _mute:   Config.darkMode ? ThemeDark.muted       : ThemeLight.muted
  readonly property color _card:   Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
  readonly property color _tile:   Config.darkMode ? ThemeDark.background1 : ThemeLight.background1
  readonly property color _accent: Config.darkMode ? ThemeDark.primary0    : ThemeLight.primary0

  function toggle() { visible ? hide() : show(); }

  function show() {
    Hyprland.refreshMonitors();
    Hyprland.refreshToplevels();
    selectedWs = activeWs;
    closeTimer.stop();
    visible = true;
    _open = true;
    keys.forceActiveFocus();
  }

  function hide() {
    if (!visible) return;
    _open = false;
    dragTop = null;
    closeTimer.restart();
  }

  function goTo(ws) {
    Hyprland.dispatch(`hl.dsp.focus({ workspace = ${ws} })`);
    hide();
  }

  function focusWindow(top) {
    Hyprland.dispatch(`hl.dsp.focus({ window = "address:0x${top.address}" })`);
    hide();
  }

  function moveWindow(top, ws) {
    Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${ws}, window = "address:0x${top.address}", follow = false })`);
    refreshTimer.restart();
  }

  function windowsOn(ws) {
    return (Hyprland.toplevels.values || []).filter(t => t.workspace?.id === ws && t.lastIpcObject?.at);
  }

  Timer {
    id: closeTimer
    interval: Motion.exitDuration
    onTriggered: overview.visible = false
  }

  // Window geometry (lastIpcObject) is only refreshed on request.
  Timer {
    id: refreshTimer
    interval: 80
    onTriggered: Hyprland.refreshToplevels()
  }

  Connections {
    target: Hyprland
    enabled: overview.visible
    function onRawEvent(event) {
      if (["openwindow", "closewindow", "movewindowv2", "changefloatingmode", "fullscreen"].includes(event.name))
        refreshTimer.restart();
    }
  }

  // Dim backdrop; clicking it closes the overview.
  Rectangle {
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.5)
    opacity: overview._open ? 1 : 0
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }

    MouseArea {
      anchors.fill: parent
      onClicked: overview.hide()
    }
  }

  Item {
    id: keys
    focus: true
    Keys.onPressed: (event) => {
      const n = overview.workspaceCount, c = overview.columns;
      let ws = overview.selectedWs;
      switch (event.key) {
      case Qt.Key_Escape: overview.hide(); break;
      case Qt.Key_Left:   ws = ws > 1 ? ws - 1 : n; break;
      case Qt.Key_Right:  ws = ws < n ? ws + 1 : 1; break;
      case Qt.Key_Up:     ws = ws - c >= 1 ? ws - c : ws + c; break;
      case Qt.Key_Down:   ws = ws + c <= n ? ws + c : ws - c; break;
      case Qt.Key_Return:
      case Qt.Key_Enter:  overview.goTo(ws); break;
      default:
        if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9)
          overview.goTo(event.key === Qt.Key_0 ? 10 : event.key - Qt.Key_0);
        else return;
      }
      overview.selectedWs = ws;
      event.accepted = true;
    }
  }

  // ── Card ───────────────────────────────────────────────────────────
  Rectangle {
    id: card
    anchors.centerIn: parent
    width: grid.width + 28
    height: grid.height + hint.height + 38
    radius: Config.rounding
    color: overview._card
    border.width: 1
    border.color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06)

    opacity: overview._open ? 1 : 0
    scale: overview._open ? 1 : 0.94
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
    Behavior on scale {
      Anim {
        curve: overview._open ? Motion.spatial : Motion.accel
        duration: overview._open ? Motion.spatialDuration : Motion.exitDuration
      }
    }

    // Swallow clicks on the card's padding so they don't reach the backdrop.
    MouseArea { anchors.fill: parent }

    Grid {
      id: grid
      x: 14
      y: 14
      columns: overview.columns
      spacing: overview.gap

      Repeater {
        id: tiles
        model: overview.workspaceCount

        delegate: Rectangle {
          id: tile
          required property int index
          readonly property int ws: index + 1
          readonly property bool isActive: ws === overview.activeWs
          readonly property bool isDrop: overview.dragTop !== null && overview.dropWs === ws
          readonly property var tops: overview.windowsOn(ws)

          width: overview.tileW
          height: overview.tileH
          radius: 10
          color: overview._tile
          border.width: isActive || isDrop || ws === overview.selectedWs ? 2 : 1
          border.color: isDrop ? overview._fg
                      : isActive ? overview._accent
                      : ws === overview.selectedWs ? overview._dim
                      : (Config.darkMode ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06))
          Behavior on border.color { CAnim {} }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: overview.selectedWs = tile.ws
            onClicked: overview.goTo(tile.ws)
          }

          // Windows at their real position, scaled down.
          Item {
            anchors.fill: parent
            anchors.margins: 1
            clip: true

            Repeater {
              model: tile.tops

              delegate: Rectangle {
                id: win
                required property var modelData
                readonly property var ipc: modelData.lastIpcObject
                readonly property var mon: overview.monitor?.lastIpcObject
                readonly property string appId: modelData.wayland?.appId || ipc?.class || ""
                readonly property bool dragging: overview.dragTop === modelData

                x: (ipc.at[0] - (mon?.x ?? 0)) * overview.ratio
                y: (ipc.at[1] - (mon?.y ?? 0)) * overview.ratio
                width: Math.max(8, ipc.size[0] * overview.ratio)
                height: Math.max(8, ipc.size[1] * overview.ratio)
                z: ipc.floating ? 2 : (ipc.fullscreen ? 1 : 0)
                radius: 4
                color: Config.darkMode ? ThemeDark.background2 : ThemeLight.background2
                border.width: 1
                border.color: winMouse.containsMouse ? overview._fg
                            : (Config.darkMode ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.12))
                opacity: dragging ? 0.35 : 1
                clip: true

                ScreencopyView {
                  id: preview
                  anchors.fill: parent
                  anchors.margins: 1
                  captureSource: overview.visible ? win.modelData.wayland : null
                  live: overview._open
                  constraintSize: Qt.size(width, height)
                }

                WinIcon {
                  anchors.centerIn: parent
                  appId: win.appId
                  size: Math.min(28, Math.min(win.width, win.height) * 0.45)
                  // Shown over the preview only on hover, or alone if the
                  // capture has nothing yet.
                  opacity: !preview.hasContent || winMouse.containsMouse ? 1 : 0
                  Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
                }

                MouseArea {
                  id: winMouse
                  anchors.fill: parent
                  hoverEnabled: true
                  acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                  cursorShape: overview.dragTop ? Qt.ClosedHandCursor : Qt.PointingHandCursor

                  property point pressAt
                  onEntered: overview.selectedWs = tile.ws

                  onPressed: (mouse) => pressAt = Qt.point(mouse.x, mouse.y)

                  onPositionChanged: (mouse) => {
                    if (!(mouse.buttons & Qt.LeftButton)) return;
                    if (!overview.dragTop && Math.hypot(mouse.x - pressAt.x, mouse.y - pressAt.y) < 6) return;
                    if (!overview.dragTop) {
                      ghost.width = win.width;
                      ghost.height = win.height;
                      ghost.grab = pressAt;
                      ghost.source = win.modelData.wayland;
                      ghost.appId = win.appId;
                      overview.dragTop = win.modelData;
                    }
                    const p = mapToItem(ghost.parent, mouse.x, mouse.y);
                    ghost.x = p.x - ghost.grab.x;
                    ghost.y = p.y - ghost.grab.y;
                    overview.dropWs = overview.tileAt(p);
                  }

                  onReleased: (mouse) => {
                    if (mouse.button === Qt.MiddleButton) {
                      win.modelData.wayland?.close();
                      refreshTimer.restart();
                      return;
                    }
                    const top = overview.dragTop;
                    overview.dragTop = null;
                    if (!top) overview.focusWindow(win.modelData);
                    else if (overview.dropWs > 0 && overview.dropWs !== tile.ws) overview.moveWindow(top, overview.dropWs);
                  }
                }
              }
            }
          }

          StyledText {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 8
            text: tile.ws
            font.pixelSize: Config.fontSize - 3
            font.weight: tile.isActive ? Font.Medium : Font.Normal
            color: tile.isActive ? overview._fg : overview._dim
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, 0.5)
          }
        }
      }
    }

    StyledText {
      id: hint
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: grid.bottom
      anchors.topMargin: 10
      text: "click focus · drag move · middle-click close · arrows/enter or 1-0 go · esc close"
      font.pixelSize: Config.fontSize - 6
      font.letterSpacing: 0.8
      color: overview._mute
    }
  }

  // Workspace number under a point in the overview's coordinates, or -1.
  function tileAt(p) {
    for (let i = 0; i < tiles.count; i++) {
      const t = tiles.itemAt(i);
      const q = t.mapFromItem(ghost.parent, p.x, p.y);
      if (t.contains(q)) return i + 1;
    }
    return -1;
  }

  // The dragged window follows the cursor above every tile.
  Rectangle {
    id: ghost
    property point grab
    property var source: null
    property string appId: ""
    visible: overview.dragTop !== null
    z: 100
    radius: 4
    color: Config.darkMode ? ThemeDark.background2 : ThemeLight.background2
    border.width: 1
    border.color: overview._fg
    clip: true

    ScreencopyView {
      id: ghostPreview
      anchors.fill: parent
      anchors.margins: 1
      captureSource: ghost.visible ? ghost.source : null
      live: true
      constraintSize: Qt.size(width, height)
    }

    WinIcon {
      anchors.centerIn: parent
      appId: ghost.appId
      size: Math.min(28, Math.min(ghost.width, ghost.height) * 0.45)
      visible: !ghostPreview.hasContent
    }
  }

  // Grayscale app icon, or a glyph when no icon matches.
  component WinIcon: Item {
    property string appId
    property real size: 24
    readonly property string _src: AppIcons.source(appId)
    width: size
    height: size

    IconImage {
      id: icon
      anchors.fill: parent
      asynchronous: true
      source: parent._src
      visible: false
    }
    MultiEffect {
      anchors.fill: icon
      source: icon
      visible: parent._src.length > 0
      saturation: -1
    }
    StyledText {
      anchors.centerIn: parent
      visible: parent._src.length === 0
      text: "󰖯"
      font.pixelSize: parent.size * 0.8
      color: overview._fg
    }
  }

  IpcHandler {
    target: "overview"
    function toggle(): void { overview.toggle(); }
    function open(): void   { overview.show(); }
    function close(): void  { overview.hide(); }
  }
}
