import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

DockedPanel {
  id: btMenu
  edge: "bottom"
  visible: false
  cardWidth: 340
  color: "transparent"
  objectName: "Bluetooth Menu"
  cardHeight: mainLayout.implicitHeight + 28

  property alias timer: timer

  readonly property color _fg:   Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _acc:  Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color _dim:  Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _mute: Config.darkMode ? ThemeDark.muted       : ThemeLight.muted
  readonly property color _line: Config.darkMode ? Qt.rgba(1,1,1,0.07)   : Qt.rgba(0,0,0,0.07)

  onVisibleChanged: {
    BluetoothService.watching = visible;
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

  component SectionLabel: StyledText {
    Layout.fillWidth: true
    Layout.topMargin: 4
    font.pixelSize: Config.fontSize - 5
    font.letterSpacing: 1.6
    color: btMenu._dim
  }

  component DeviceList: ColumnLayout {
    property var devices: []
    Layout.fillWidth: true
    spacing: 2
    Repeater {
      model: parent.devices
      delegate: BtRow {
        required property var modelData
        Layout.fillWidth: true
        device: modelData
        onActivated: BluetoothService.activate(modelData)
        onForgetRequested: BluetoothService.forget(modelData.mac)
      }
    }
  }

  ColumnLayout {
    id: mainLayout
    spacing: 8
    width: parent.width - 28
    x: 14
    y: 14

    // ── Header ────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      StyledText {
        text: BluetoothService.powered
          ? (BluetoothService.connectedCount > 0 ? "󰂱" : "󰂯")
          : "󰂲"
        font.pixelSize: Config.fontSize + 4
        color: BluetoothService.powered ? btMenu._acc : btMenu._mute
      }
      ColumnLayout {
        spacing: 0
        StyledText {
          text: "Bluetooth"
          font.pixelSize: Config.fontSize - 1
          font.letterSpacing: 1.4
          color: btMenu._fg
        }
        StyledText {
          text: !BluetoothService.powered ? "off"
              : BluetoothService.connectedCount > 0
                ? BluetoothService.connectedCount + " connected"
                : "on · no devices connected"
          font.pixelSize: Config.fontSize - 5
          color: btMenu._dim
        }
      }
      Item { Layout.fillWidth: true }
      Toggle {
        checked: BluetoothService.powered
        onToggled: BluetoothService.togglePower()
      }
    }

    // Divider; becomes a sweeping bar while scanning.
    Item {
      Layout.fillWidth: true
      implicitHeight: 2

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 1
        color: btMenu._line
      }
      Rectangle {
        id: sweep
        visible: BluetoothService.scanning
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.3
        height: 2
        radius: 1
        color: btMenu._fg
        opacity: 0.6
        SequentialAnimation on x {
          running: sweep.visible
          loops: Animation.Infinite
          NumberAnimation { from: -sweep.width; to: sweep.parent.width; duration: 1200; easing.type: Easing.InOutQuad }
        }
      }
    }

    // ── Devices ───────────────────────────────────────────
    Flickable {
      Layout.fillWidth: true
      Layout.preferredHeight: Math.min(320, devCol.implicitHeight)
      visible: BluetoothService.powered
      contentHeight: devCol.implicitHeight
      boundsBehavior: Flickable.StopAtBounds
      clip: true

      ColumnLayout {
        id: devCol
        width: parent.width
        spacing: 4

        SectionLabel {
          visible: BluetoothService.connectedDevices.length > 0
          text: "CONNECTED"
        }
        DeviceList { devices: BluetoothService.connectedDevices }

        SectionLabel {
          visible: BluetoothService.pairedDevices.length > 0
          text: "PAIRED"
        }
        DeviceList { devices: BluetoothService.pairedDevices }

        RowLayout {
          Layout.fillWidth: true
          Layout.topMargin: 4
          SectionLabel {
            Layout.topMargin: 0
            text: "AVAILABLE"
          }
          BtPill {
            icon: "󰐷"
            label: BluetoothService.scanning ? "scanning" : "scan"
            active: BluetoothService.scanning
            onClicked: BluetoothService.toggleScan()
          }
        }
        DeviceList { devices: BluetoothService.availableDevices }

        StyledText {
          visible: BluetoothService.availableDevices.length === 0
          Layout.fillWidth: true
          text: BluetoothService.scanning ? "Looking for devices…" : "Scan to find new devices"
          font.pixelSize: Config.fontSize - 4
          color: btMenu._mute
        }
      }
    }

    StyledText {
      visible: BluetoothService.lastError.length > 0
      Layout.fillWidth: true
      text: BluetoothService.lastError
      elide: Text.ElideRight
      font.pixelSize: Config.fontSize - 4
      color: Config.darkMode ? ThemeDark.error : ThemeLight.error
    }

    StyledText {
      visible: !BluetoothService.powered
      Layout.fillWidth: true
      Layout.topMargin: 4
      Layout.bottomMargin: 4
      horizontalAlignment: Text.AlignHCenter
      text: "Bluetooth is off"
      font.pixelSize: Config.fontSize - 2
      color: btMenu._dim
    }
  }
}
