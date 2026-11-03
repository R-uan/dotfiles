import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

// App shortcuts, dock style: grayscale app icons that light up on hover,
// a dot under apps that already have a window, and the name in a tooltip.
// Click focuses an open window (or launches the app); middle-click always
// launches a new one.
Item {
  id: root
  implicitHeight: 52

  readonly property var apps: Config.startMenuApps

  // Must be detached. A Quickshell Process is a child of quickshell and gets
  // killed when quickshell exits or reloads its config. Apps that fork and
  // detach on their own (zen, code, vesktop) survive that regardless, but
  // Steam's NixOS wrapper execs into bwrap and stays in the foreground for the
  // whole session, so it died with the Process object instead of ever opening.
  // Launcher.qml already launches this way.
  function launch(cmd) {
    Quickshell.execDetached(cmd);
  }

  function windowsOf(app) {
    if (!app.appId) return [];
    const id = app.appId.toLowerCase();
    return (Hyprland.toplevels.values || []).filter(t =>
      (t.wayland?.appId || t.lastIpcObject?.class || "").toLowerCase().startsWith(id));
  }

  function open(app, forceNew) {
    if (app.launcher) {
      launcher.visible = true;
      return;
    }
    const wins = forceNew ? [] : windowsOf(app);
    if (wins.length > 0)
      Hyprland.dispatch(`hl.dsp.focus({ window = "address:0x${wins[0].address}" })`);
    else
      launch(app.command);
    startmenu.visible = false;
  }

  readonly property color _fg:  Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _acc: Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1

  RowLayout {
    anchors.fill: parent
    spacing: 4

    Repeater {
      model: root.apps

      delegate: Item {
        id: cell
        required property var modelData
        readonly property bool hot: ma.containsMouse
        readonly property int running: root.windowsOf(modelData).length
        readonly property string iconSrc: modelData.entry
          ? Quickshell.iconPath(DesktopEntries.byId(modelData.entry)?.icon ?? "", true)
          : ""

        Layout.fillWidth: true
        Layout.preferredHeight: root.implicitHeight

        Rectangle {
          id: tileBg
          anchors.horizontalCenter: parent.horizontalCenter
          y: 2
          width: 42
          height: 42
          radius: 12
          color: cell.hot
            ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
            : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04))
          border.color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
          border.width: 1
          Behavior on color { CAnim {} }

          scale: ma.pressed ? 0.9 : cell.hot ? 1.06 : 1
          Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }

          IconImage {
            id: appIcon
            anchors.centerIn: parent
            width: 24
            height: 24
            asynchronous: true
            source: cell.iconSrc
            visible: false
          }
          MultiEffect {
            anchors.fill: appIcon
            source: appIcon
            visible: cell.iconSrc.length > 0
            saturation: -1
            brightness: cell.hot ? 0.08 : 0
            opacity: cell.hot || cell.running > 0 ? 1 : 0.7
            Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
          }
          StyledText {
            anchors.centerIn: parent
            visible: cell.iconSrc.length === 0
            text: cell.modelData.icon
            font.pixelSize: 20
            color: cell.hot ? root._fg : root._acc
            Behavior on color { CAnim {} }
          }
        }

        // Running indicator: a dot, a short bar for several windows.
        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: tileBg.bottom
          anchors.topMargin: 3
          width: cell.running > 1 ? 10 : 4
          height: 4
          radius: 2
          color: root._fg
          opacity: cell.running > 0 ? 0.8 : 0
          Behavior on width { Anim { duration: Motion.fastSpatialDuration } }
          Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
        }

        // Name tooltip above the tile.
        Rectangle {
          anchors.horizontalCenter: tileBg.horizontalCenter
          anchors.bottom: tileBg.top
          anchors.bottomMargin: 6
          z: 10
          width: tipText.implicitWidth + 14
          height: 20
          radius: 6
          color: Config.darkMode ? ThemeDark.background2 : ThemeLight.background2
          border.width: 1
          border.color: Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.08)
          opacity: cell.hot ? 1 : 0
          visible: opacity > 0
          Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }

          StyledText {
            id: tipText
            anchors.centerIn: parent
            text: cell.modelData.name + (cell.running > 1 ? " · " + cell.running : "")
            font.pixelSize: Config.fontSize - 4
            color: root._fg
          }
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.LeftButton | Qt.MiddleButton
          cursorShape: Qt.PointingHandCursor
          onClicked: (mouse) => root.open(cell.modelData, mouse.button === Qt.MiddleButton)
        }
      }
    }
  }
}
