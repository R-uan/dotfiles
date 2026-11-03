import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

// Session screen (replaces the power card): full-screen, dimmed, five big
// actions. Click one, or use arrows + Enter, or its letter key
// (L lock · S suspend · E log out · R restart · P shut down). Esc or a
// click outside closes it.
PanelWindow {
  id: session
  visible: false
  color: "transparent"
  objectName: "Session"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell:session"
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

  anchors { top: true; left: true; right: true; bottom: true }

  property alias timer: closeTimer
  // The lock screen object from shell.qml.
  property var lockScreen
  property int selected: 0
  property bool _open: false

  // Detached: a Quickshell Process dies with quickshell.
  readonly property var actions: [
    { key: Qt.Key_L, letter: "L", icon: "󰌾", label: "Lock",      run: () => session.lockScreen.lock() },
    { key: Qt.Key_S, letter: "S", icon: "󰒲", label: "Suspend",   run: () => Quickshell.execDetached(["systemctl", "suspend"]) },
    { key: Qt.Key_E, letter: "E", icon: "󰍃", label: "Log out",   run: () => Hyprland.dispatch("hl.dsp.exit()") },
    { key: Qt.Key_R, letter: "R", icon: "󰜉", label: "Restart",   run: () => Quickshell.execDetached(["systemctl", "reboot"]) },
    { key: Qt.Key_P, letter: "P", icon: "󰐥", label: "Shut down", run: () => Quickshell.execDetached(["systemctl", "poweroff"]) }
  ]

  function toggle() { visible ? hide() : show(); }

  function show() {
    closeTimer.stop();
    selected = 0;
    visible = true;
    _open = true;
    keys.forceActiveFocus();
  }

  function hide() {
    if (!visible) return;
    _open = false;
    closeTimer.restart();
  }

  // Close first, so the screen isn't in the way (or captured by the lock).
  function run(i) {
    const a = actions[i];
    _open = false;
    visible = false;
    a.run();
  }

  Timer {
    id: closeTimer
    interval: Motion.exitDuration
    onTriggered: session.visible = false
  }

  readonly property color _fg:  Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _dim: Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3

  Rectangle {
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.72)
    opacity: session._open ? 1 : 0
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }

    MouseArea {
      anchors.fill: parent
      onClicked: session.hide()
    }
  }

  Item {
    id: keys
    focus: true
    Keys.onPressed: (event) => {
      const n = session.actions.length;
      if (event.key === Qt.Key_Escape) session.hide();
      else if (event.key === Qt.Key_Left || event.key === Qt.Key_Backtab) session.selected = (session.selected + n - 1) % n;
      else if (event.key === Qt.Key_Right || event.key === Qt.Key_Tab) session.selected = (session.selected + 1) % n;
      else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) session.run(session.selected);
      else {
        const i = session.actions.findIndex(a => a.key === event.key);
        if (i < 0) return;
        session.run(i);
      }
      event.accepted = true;
    }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 36
    opacity: session._open ? 1 : 0
    scale: session._open ? 1 : 0.94
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
    Behavior on scale {
      Anim {
        curve: session._open ? Motion.spatial : Motion.accel
        duration: session._open ? Motion.spatialDuration : Motion.exitDuration
      }
    }

    ColumnLayout {
      Layout.alignment: Qt.AlignHCenter
      spacing: 4
      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: "Goodbye, " + (Quickshell.env("USER") || "you")
        font.pixelSize: Config.fontSize + 10
        color: session._fg
      }
      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: "up " + UptimeService.uptimeShort
        font.pixelSize: Config.fontSize - 2
        font.letterSpacing: 1.2
        color: session._dim
      }
    }

    Row {
      Layout.alignment: Qt.AlignHCenter
      spacing: 18

      Repeater {
        model: session.actions

        delegate: Item {
          id: btn
          required property var modelData
          required property int index
          readonly property bool sel: session.selected === index
          width: 124
          height: 150

          Rectangle {
            id: face
            width: 124
            height: 124
            radius: btn.sel ? 62 : 28
            color: btn.sel ? Qt.rgba(1, 1, 1, 0.90) : Qt.rgba(1, 1, 1, 0.07)
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, btn.sel ? 0 : 0.10)
            scale: ma.pressed ? 0.92 : 1
            Behavior on radius { Anim { duration: Motion.fastSpatialDuration } }
            Behavior on color { CAnim {} }
            Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }

            StyledText {
              anchors.centerIn: parent
              text: btn.modelData.icon
              font.pixelSize: 40
              color: btn.sel ? "#151515" : session._fg
              Behavior on color { CAnim {} }
            }
          }

          StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            text: btn.modelData.label + "  ·  " + btn.modelData.letter
            font.pixelSize: Config.fontSize - 3
            font.letterSpacing: 0.8
            color: btn.sel ? session._fg : session._dim
            Behavior on color { CAnim {} }
          }

          MouseArea {
            id: ma
            anchors.fill: face
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: session.selected = btn.index
            onClicked: session.run(btn.index)
          }
        }
      }
    }
  }

  IpcHandler {
    target: "session"
    function toggle(): void { session.toggle(); }
    function open(): void   { session.show(); }
  }
}
