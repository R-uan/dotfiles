import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  property var device
  signal activated()
  signal forgetRequested()

  implicitHeight: 34

  function _iconFor(kind) {
    const k = String(kind || "").toLowerCase();
    if (k.includes("headset") || k.includes("headphone")) return "󰋋";
    if (k.includes("keyboard"))                            return "󰌌";
    if (k.includes("mouse") || k.includes("pointer"))      return "󰍽";
    if (k.includes("phone"))                               return "󰦧";
    if (k.includes("audio") || k.includes("speaker"))      return "󰓃";
    if (k.includes("computer") || k.includes("laptop"))    return "";
    if (k.includes("watch"))                               return "";
    if (k.includes("game") || k.includes("joypad"))        return "󰊴";
    return "󰂯"; // generic bluetooth
  }

  readonly property bool _connected: device && device.connected
  readonly property bool _paired:    device && device.paired

  Rectangle {
    anchors.fill: parent
    radius: 6
    color: root._connected
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.09) : Qt.rgba(0,0,0,0.07))
      : (ma.containsMouse
          ? (Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.05))
          : "transparent")
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 8
    anchors.rightMargin: 6
    spacing: 8

    StyledText {
      text: root._iconFor(root.device ? root.device.icon : "")
      font.pixelSize: Config.fontSize + 1
      color: root._connected
        ? (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
        : (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: -1

      StyledText {
        Layout.fillWidth: true
        text: root.device ? root.device.name : ""
        font.pixelSize: Config.fontSize - 2
        font.weight: root._connected ? Font.Medium : Font.Normal
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
        elide: Text.ElideRight
      }
      StyledText {
        Layout.fillWidth: true
        text: root._connected ? "connected" : (root._paired ? "paired" : "available")
        font.pixelSize: Config.fontSize - 5
        font.letterSpacing: 1.2
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
    }

    // Forget (only for paired, non-connected)
    Item {
      visible: root._paired && !root._connected
      implicitWidth: 22
      implicitHeight: 22
      Rectangle {
        anchors.fill: parent
        radius: 5
        color: forgetBtn.containsMouse
          ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
          : "transparent"
        Behavior on color { ColorAnimation { duration: 110 } }
      }
      StyledText {
        anchors.centerIn: parent
        text: "󰩹"
        font.pixelSize: Config.fontSize - 2
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
      MouseArea {
        id: forgetBtn
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.forgetRequested()
      }
    }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.activated()
    z: -1
  }
}
