import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
  id: netMenu
  visible: false
  implicitWidth: 340
  color: "transparent"
  objectName: "Network Menu"
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
  property string expandedSsid: ""

  onVisibleChanged: {
    if (visible) {
      NetworkService.refresh();
      if (NetworkService.wifiEnabled) NetworkService.rescan();
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: netMenu.visible = false
  }

  HoverHandler {
    id: hoverHandler
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
        text: NetworkService.icon
        font.pixelSize: Config.fontSize + 4
        color: NetworkService.netState === "connected"
          ? (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
          : (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
      }
      StyledText {
        text: "Network"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: NetworkService.netState === "connected" ? "online" : "offline"
        font.pixelSize: Config.fontSize - 4
        font.letterSpacing: 1.4
        color: NetworkService.netState === "connected"
          ? (Config.darkMode ? ThemeDark.success : ThemeLight.success)
          : (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
      }
    }

    // Divider
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // Current connection block
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 4

      RowLayout {
        Layout.fillWidth: true
        StyledText {
          text: NetworkService.connName
          font.pixelSize: Config.fontSize - 1
          font.weight: Font.Medium
          color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
          elide: Text.ElideRight
          Layout.fillWidth: true
        }
        StyledText {
          visible: NetworkService.type === "wifi" && NetworkService.netState === "connected"
          text: NetworkService.signalStrength + "%"
          font.pixelSize: Config.fontSize - 3
          color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 6
        StyledText {
          text: NetworkService.type === "ethernet" ? " ethernet"
              : NetworkService.type === "wifi"     ? "󰖩 wifi"
              : "󰅛 offline"
          font.pixelSize: Config.fontSize - 4
          font.letterSpacing: 1.2
          color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        }
        Item { Layout.fillWidth: true }
        StyledText {
          visible: NetworkService.ipAddress.length > 0
          text: NetworkService.ipAddress
          font.pixelSize: Config.fontSize - 4
          color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        }
      }
    }

    // Controls
    RowLayout {
      Layout.fillWidth: true
      Layout.topMargin: 4
      spacing: 6

      NetPill {
        icon: "󰖩"
        label: NetworkService.wifiEnabled ? "wifi on" : "wifi off"
        active: NetworkService.wifiEnabled
        onClicked: NetworkService.toggleWifi()
      }
      NetPill {
        icon: "󰑐"
        label: NetworkService.scanning ? "scanning" : "rescan"
        onClicked: NetworkService.rescan()
      }
      Item { Layout.fillWidth: true }
      NetPill {
        visible: NetworkService.netState === "connected"
        icon: "󰖪"
        label: "disconnect"
        onClicked: NetworkService.disconnect()
      }
    }

    // Divider
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
      visible: NetworkService.wifiEnabled
    }

    // WiFi label row
    RowLayout {
      Layout.fillWidth: true
      visible: NetworkService.wifiEnabled

      StyledText {
        text: "NEARBY"
        font.pixelSize: Config.fontSize - 4
        font.letterSpacing: 1.6
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: NetworkService.wifiNetworks.length + " networks"
        font.pixelSize: Config.fontSize - 4
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
    }

    // Wi-Fi list (scrollable, capped height)
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: Math.min(6 * 34, wifiCol.implicitHeight)
      visible: NetworkService.wifiEnabled && NetworkService.wifiNetworks.length > 0
      radius: 8
      color: "transparent"
      clip: true

      Flickable {
        anchors.fill: parent
        contentHeight: wifiCol.implicitHeight
        clip: true

        ColumnLayout {
          id: wifiCol
          width: parent.width
          spacing: 2

          Repeater {
            model: NetworkService.wifiNetworks
            delegate: WifiRow {
              Layout.fillWidth: true
              net: modelData
              expanded: netMenu.expandedSsid === modelData.ssid
              onActivated: {
                if (modelData.inUse) return;
                if (modelData.saved) {
                  netMenu.expandedSsid = "";
                  NetworkService.connectSaved(modelData.ssid);
                } else if (!modelData.secure) {
                  netMenu.expandedSsid = "";
                  NetworkService.connectOpen(modelData.ssid);
                } else {
                  netMenu.expandedSsid =
                    (netMenu.expandedSsid === modelData.ssid) ? "" : modelData.ssid;
                }
              }
              onSubmitPassword: (pw) => {
                netMenu.expandedSsid = "";
                NetworkService.connectSecure(modelData.ssid, pw);
              }
              onCancelExpand: netMenu.expandedSsid = ""
            }
          }
        }
      }
    }

    StyledText {
      visible: NetworkService.wifiEnabled && NetworkService.wifiNetworks.length === 0
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      text: NetworkService.scanning ? "Scanning…" : "No networks in range."
      font.pixelSize: Config.fontSize - 2
      color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
    }
  }
}
