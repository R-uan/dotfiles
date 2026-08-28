import qs.shared
import qs.config

import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
  id: root
  implicitHeight: 48

  readonly property var apps: [
    { name: "Zen",         icon: "󰈹", command: ["zen"] },
    { name: "VSCode",      icon: "󰨞", command: ["code"] },
    { name: "XIVLauncher", icon: "󰊴", command: ["XIVLauncher.Core"] },
    { name: "Steam",       icon: "󰓓", command: ["steam"] },
    { name: "Vesktop",     icon: "󰙯", command: ["vesktop"] },
    { name: "Terminal",    icon: "", command: ["kitty"] },
    { name: "Siyuan",      icon: "", command: ["siyuan"] },
    { name: "All apps",    icon: "", launcher: true }
  ]

  // Must be detached. A Quickshell Process is a child of quickshell and gets
  // killed when quickshell exits or reloads its config. Apps that fork and
  // detach on their own (zen, code, vesktop) survive that regardless, but
  // Steam's NixOS wrapper execs into bwrap and stays in the foreground for the
  // whole session, so it died with the Process object instead of ever opening.
  // Launcher.qml already launches this way.
  function launch(cmd) {
    Quickshell.execDetached(cmd);
  }

  RowLayout {
    anchors.fill: parent
    spacing: 4

    Repeater {
      model: root.apps
      delegate: Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 44

        Rectangle {
          anchors.centerIn: parent
          width: 40
          height: 40
          radius: 10
          color: ma.containsMouse
            ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
            : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04))
          border.color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
          border.width: 1
          Behavior on color { ColorAnimation { duration: 110 } }

          scale: ma.pressed ? 0.94 : 1.0
          Behavior on scale { NumberAnimation { duration: 90; easing.type: Easing.OutCubic } }

          StyledText {
            anchors.centerIn: parent
            text: modelData.icon
            font.pixelSize: 20
            color: ma.containsMouse
              ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
              : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
            Behavior on color { ColorAnimation { duration: 110 } }
          }
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (modelData.launcher) {
              launcher.visible = true;
            } else {
              root.launch(modelData.command);
            }
          }
        }
      }
    }
  }
}
