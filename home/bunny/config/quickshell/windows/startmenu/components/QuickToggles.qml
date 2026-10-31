import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

// One-click switches. Left click toggles, right click opens the matching
// menu for the details (network list, devices, temperature, ...).
Item {
  id: root
  implicitHeight: 54

  readonly property var toggles: [
    {
      label: "Wi-Fi",
      active: NetworkService.wifiEnabled,
      icon: NetworkService.wifiEnabled ? "󰖩" : "󰖪",
      toggle: () => NetworkService.toggleWifi(),
      menu: networkmenu
    },
    {
      label: "Bluetooth",
      active: BluetoothService.powered,
      icon: BluetoothService.powered ? "󰂯" : "󰂲",
      toggle: () => BluetoothService.togglePower(),
      menu: bluetoothmenu
    },
    {
      label: "Night",
      active: SunsetService.enabled,
      icon: SunsetService.icon,
      toggle: () => SunsetService.toggle(),
      menu: sunsetmenu
    },
    {
      label: "Silence",
      active: NotificationService.dnd,
      icon: NotificationService.dnd ? "󰂛" : "󰂚",
      toggle: () => NotificationService.toggleDnd(),
      menu: notificationcenter
    },
    {
      label: "Caffeine",
      active: IdleService.inhibited,
      icon: IdleService.icon,
      toggle: () => IdleService.toggle(),
      menu: null
    },
    {
      label: "Mic",
      active: !AudioService.micMuted,
      icon: AudioService.micIcon,
      toggle: () => AudioService.toggleMicMute(),
      menu: audiomenu
    }
  ]

  RowLayout {
    anchors.fill: parent
    spacing: 6

    Repeater {
      model: root.toggles

      delegate: Item {
        id: tile
        required property var modelData
        readonly property bool _on: modelData.active
        Layout.fillWidth: true
        Layout.fillHeight: true

        scale: ma.pressed ? 0.95 : 1.0
        Behavior on scale { NumberAnimation { duration: 90; easing.type: Easing.OutCubic } }

        Rectangle {
          anchors.fill: parent
          radius: 10
          color: tile._on
            ? (Config.darkMode ? Qt.rgba(1,1,1, ma.containsMouse ? 0.17 : 0.13) : Qt.rgba(0,0,0, ma.containsMouse ? 0.15 : 0.11))
            : (Config.darkMode ? Qt.rgba(1,1,1, ma.containsMouse ? 0.08 : 0.03) : Qt.rgba(0,0,0, ma.containsMouse ? 0.07 : 0.03))
          border.color: tile._on
            ? (Config.darkMode ? Qt.rgba(1,1,1,0.16) : Qt.rgba(0,0,0,0.14))
            : (Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06))
          border.width: 1
          Behavior on color { ColorAnimation { duration: 140 } }
          Behavior on border.color { ColorAnimation { duration: 140 } }
        }

        ColumnLayout {
          anchors.centerIn: parent
          spacing: 3

          StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: tile.modelData.icon
            font.pixelSize: 17
            color: tile._on
              ? (Config.darkMode ? ThemeDark.foreground1 : ThemeLight.foreground1)
              : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
            Behavior on color { ColorAnimation { duration: 140 } }
          }
          StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: tile.modelData.label
            font.pixelSize: Config.fontSize - 5
            font.letterSpacing: 0.8
            color: tile._on
              ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
              : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
            Behavior on color { ColorAnimation { duration: 140 } }
          }
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton) {
              if (tile.modelData.menu) tile.modelData.menu.visible = true;
              return;
            }
            tile.modelData.toggle();
          }
        }
      }
    }
  }
}
