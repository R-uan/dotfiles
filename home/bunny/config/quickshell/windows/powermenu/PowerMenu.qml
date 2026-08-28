import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
  id: powerMenu
  visible: false
  implicitWidth: 260
  color: "transparent"
  objectName: "Power Menu"
  height: mainLayout.implicitHeight + 28
  exclusionMode: ExclusionMode.Normal

  anchors {
    bottom: true
    left: true
    right: false
    top: false
  }

  margins {
    bottom: 6
    left: 6
  }

  Background {
    radius: 14
  }

  property alias timer: timer
  // Which action is armed for confirmation ("", "poweroff", "reboot", "lock")
  property string armed: ""

  // Detached: a Quickshell Process is killed when quickshell exits or reloads
  // its config. That would tear down hyprlock along with it and drop the
  // session straight back to an unlocked desktop.
  function runCommand(cmd) {
    Quickshell.execDetached(cmd);
  }

  function trigger(action) {
    if (powerMenu.armed !== action) {
      powerMenu.armed = action;
      confirmTimer.restart();
      return;
    }
    confirmTimer.stop();
    if (action === "poweroff")     powerMenu.runCommand(["systemctl", "poweroff"]);
    else if (action === "reboot")  powerMenu.runCommand(["systemctl", "reboot"]);
    else if (action === "lock")    powerMenu.runCommand(["hyprlock"]);
    powerMenu.visible = false;
    powerMenu.armed = "";
  }

  Timer {
    id: confirmTimer
    interval: 3000
    running: false
    repeat: false
    onTriggered: powerMenu.armed = ""
  }

  ColumnLayout {
    id: mainLayout
    spacing: 10
    width: parent.width - 28
    x: 14
    y: 14

    // Header
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      StyledText {
        text: "󰐥"
        font.pixelSize: Config.fontSize + 4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      StyledText {
        text: "Power"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      Item { Layout.fillWidth: true }
    }

    // Uptime
    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      StyledText {
        text: "󰅐"
        font.pixelSize: Config.fontSize - 2
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
      StyledText {
        Layout.fillWidth: true
        text: UptimeService.uptime
        font.pixelSize: Config.fontSize - 2
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
        elide: Text.ElideRight
      }
    }

    // Divider
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // Action buttons
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      Repeater {
        model: [
          { key: "lock",     icon: "󰌾", label: "Lock" },
          { key: "reboot",   icon: "󰜉", label: "Restart" },
          { key: "poweroff", icon: "󰐥", label: "Shutdown" }
        ]

        delegate: Item {
          Layout.fillWidth: true
          Layout.preferredHeight: 68
          property bool isArmed: powerMenu.armed === modelData.key

          Rectangle {
            anchors.fill: parent
            radius: 10
            color: btnArea.containsMouse
              ? (Config.darkMode ? Qt.rgba(1,1,1,0.11) : Qt.rgba(0,0,0,0.09))
              : (Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.04))
            border.color: isArmed
              ? (Config.darkMode ? ThemeDark.warning : ThemeLight.warning)
              : (Config.darkMode ? Qt.rgba(1,1,1,0.09) : Qt.rgba(0,0,0,0.09))
            border.width: isArmed ? 2 : 1
            Behavior on color { ColorAnimation { duration: 110 } }
            Behavior on border.color { ColorAnimation { duration: 110 } }
          }

          ColumnLayout {
            anchors.centerIn: parent
            spacing: 4

            StyledText {
              text: modelData.icon
              font.pixelSize: 22
              Layout.alignment: Qt.AlignHCenter
              color: isArmed
                ? (Config.darkMode ? ThemeDark.warning : ThemeLight.warning)
                : (btnArea.containsMouse
                    ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
                    : (Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3))
              Behavior on color { ColorAnimation { duration: 110 } }
            }

            StyledText {
              Layout.alignment: Qt.AlignHCenter
              text: isArmed ? "Confirm?" : modelData.label
              font.pixelSize: Config.fontSize - 3
              color: isArmed
                ? (Config.darkMode ? ThemeDark.warning : ThemeLight.warning)
                : (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
            }
          }

          MouseArea {
            id: btnArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: powerMenu.trigger(modelData.key)
          }
        }
      }
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: {
      powerMenu.visible = false;
      powerMenu.armed = "";
    }
  }

  MouseArea {
    id: area
    hoverEnabled: true
    anchors.fill: parent
    propagateComposedEvents: true
    onExited: timer.running = true
    onEntered: {
      timer.running = false
      timer.interval = 1000
    }
  }
}
