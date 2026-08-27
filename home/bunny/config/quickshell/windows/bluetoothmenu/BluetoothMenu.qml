import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
  id: btMenu
  visible: false
  implicitWidth: 340
  color: "transparent"
  objectName: "Bluetooth Menu"
  implicitHeight: mainLayout.implicitHeight + 28
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

  onVisibleChanged: {
    if (visible) BluetoothService.refresh();
  }

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: btMenu.visible = false
  }

  HoverHandler {
    onHoveredChanged: {
      if (hovered) timer.stop();
      else         timer.restart();
    }
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
        text: BluetoothService.powered
          ? (BluetoothService.connectedCount > 0 ? "󰂱" : "󰂯")
          : "󰂲"
        font.pixelSize: Config.fontSize + 4
        color: BluetoothService.powered
          ? (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
          : (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
      }
      StyledText {
        text: "Bluetooth"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: !BluetoothService.powered ? "off"
            : BluetoothService.connectedCount > 0 ? "connected"
            : "on"
        font.pixelSize: Config.fontSize - 4
        font.letterSpacing: 1.4
        color: !BluetoothService.powered
          ? (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
          : (BluetoothService.connectedCount > 0
              ? (Config.darkMode ? ThemeDark.success : ThemeLight.success)
              : (Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3))
      }
    }

    // Divider
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // Controls
    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      BtPill {
        icon: "󰂯"
        label: BluetoothService.powered ? "on" : "off"
        active: BluetoothService.powered
        onClicked: BluetoothService.togglePower()
      }
      BtPill {
        visible: BluetoothService.powered
        icon: "󰐷"
        label: BluetoothService.scanning ? "scanning" : "scan"
        active: BluetoothService.scanning
        onClicked: BluetoothService.toggleScan()
      }
      Item { Layout.fillWidth: true }
    }

    // Divider
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
      visible: BluetoothService.powered
    }

    // Section label
    RowLayout {
      Layout.fillWidth: true
      visible: BluetoothService.powered

      StyledText {
        text: "DEVICES"
        font.pixelSize: Config.fontSize - 4
        font.letterSpacing: 1.6
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: BluetoothService.devices.length + " known"
        font.pixelSize: Config.fontSize - 4
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
    }

    // Device list (scrollable, capped)
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: Math.min(6 * 36, devCol.implicitHeight)
      visible: BluetoothService.powered && BluetoothService.devices.length > 0
      radius: 8
      color: "transparent"
      clip: true

      Flickable {
        anchors.fill: parent
        contentHeight: devCol.implicitHeight
        clip: true

        ColumnLayout {
          id: devCol
          width: parent.width
          spacing: 2

          Repeater {
            model: BluetoothService.devices
            delegate: BtRow {
              Layout.fillWidth: true
              device: modelData
              onActivated: {
                if (!modelData) return;
                if (modelData.connected) BluetoothService.disconnect(modelData.mac);
                else if (modelData.paired) BluetoothService.connect(modelData.mac);
                else {
                  BluetoothService.pair(modelData.mac);
                  BluetoothService.trust(modelData.mac);
                  BluetoothService.connect(modelData.mac);
                }
              }
              onForgetRequested: BluetoothService.forget(modelData.mac)
            }
          }
        }
      }
    }

    StyledText {
      visible: BluetoothService.powered && BluetoothService.devices.length === 0
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      text: BluetoothService.scanning ? "Scanning…" : "No devices. Press scan."
      font.pixelSize: Config.fontSize - 2
      color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
    }

    StyledText {
      visible: !BluetoothService.powered
      Layout.fillWidth: true
      Layout.topMargin: 4
      horizontalAlignment: Text.AlignHCenter
      text: "Bluetooth is off"
      font.pixelSize: Config.fontSize - 2
      color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
    }
  }
}
