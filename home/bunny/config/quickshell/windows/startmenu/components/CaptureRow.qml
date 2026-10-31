import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

// Screenshots (hyprshot, same as the Print keybinds), screen recording
// (RecorderService) and the clipboard panel.
Item {
  id: root
  implicitHeight: 44

  // Give the start menu time to close so it isn't in the shot.
  function shoot(mode) {
    startmenu.visible = false;
    Quickshell.execDetached(["sh", "-c",
      "sleep 0.35; hyprshot " + (mode === "region" ? "--freeze -m region" : "-m window") + " --clipboard-only"]);
  }

  function record(mode) {
    startmenu.visible = false;
    RecorderService.toggle(mode);
  }

  readonly property var actions: [
    { label: "Region",  icon: "󰆞", run: () => root.shoot("region") },
    { label: "Window",  icon: "󰖯", run: () => root.shoot("window") },
    { label: RecorderService.recording ? "Stop" : "Record",
      icon: RecorderService.recording ? "󰓛" : "󰑊",
      active: RecorderService.recording,
      run: () => root.record("region") },
    { label: "Screen",  icon: "󰍹", run: () => root.record("screen"), hidden: RecorderService.recording },
    { label: RecorderService.withAudio ? "Audio" : "Muted",
      icon: RecorderService.withAudio ? "󰕾" : "󰖁",
      active: RecorderService.withAudio,
      run: () => RecorderService.withAudio = !RecorderService.withAudio },
    { label: "Clipboard", icon: "󰅌", run: () => { clipboard.visible = true; } }
  ]

  RowLayout {
    anchors.fill: parent
    spacing: 6

    Repeater {
      model: root.actions.filter(a => !a.hidden)

      delegate: Item {
        id: tile
        required property var modelData
        Layout.fillWidth: true
        Layout.fillHeight: true

        scale: ma.pressed ? 0.95 : 1.0
        Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }

        Rectangle {
          anchors.fill: parent
          radius: 10
          color: tile.modelData.active
            ? (Config.darkMode ? Qt.rgba(1,1,1, ma.containsMouse ? 0.17 : 0.12) : Qt.rgba(0,0,0, ma.containsMouse ? 0.15 : 0.10))
            : (Config.darkMode ? Qt.rgba(1,1,1, ma.containsMouse ? 0.08 : 0.03) : Qt.rgba(0,0,0, ma.containsMouse ? 0.07 : 0.03))
          border.width: 1
          border.color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
          Behavior on color { CAnim {} }
        }

        RowLayout {
          anchors.centerIn: parent
          spacing: 5

          StyledText {
            text: tile.modelData.icon
            font.pixelSize: 14
            color: ma.containsMouse || tile.modelData.active
              ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
              : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
          }
          StyledText {
            text: tile.modelData.label
            font.pixelSize: Config.fontSize - 5
            color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
            visible: tile.width > 60
          }
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: tile.modelData.run()
        }
      }
    }
  }
}
