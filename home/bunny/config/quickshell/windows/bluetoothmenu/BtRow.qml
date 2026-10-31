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

  implicitHeight: 42

  function _iconFor(kind) {
    const k = String(kind || "").toLowerCase();
    if (k.includes("headset") || k.includes("headphone")) return "󰋋";
    if (k.includes("keyboard"))                            return "󰌌";
    if (k.includes("mouse") || k.includes("pointer"))      return "󰍽";
    if (k.includes("phone"))                               return "󰦧";
    if (k.includes("audio") || k.includes("speaker"))      return "󰓃";
    if (k.includes("computer") || k.includes("laptop"))    return "󰌢";
    if (k.includes("watch"))                               return "󰢗";
    if (k.includes("game") || k.includes("joypad"))        return "󰊴";
    return "󰂯"; // generic bluetooth
  }

  function _batteryIcon(pct) {
    const steps = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾",
                   "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
    return steps[Math.max(0, Math.min(9, Math.ceil(pct / 10) - 1))];
  }

  readonly property bool _connected: device && device.connected
  readonly property bool _paired:    device && device.paired
  readonly property bool _busy:      device && BluetoothService.busyMac === device.mac
  readonly property int  _battery:   device ? device.battery : -1

  readonly property color _fg:  Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _acc: Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color _dim: Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3

  Rectangle {
    anchors.fill: parent
    radius: 8
    color: ma.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.05))
      : "transparent"
    Behavior on color { CAnim {} }
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 6
    anchors.rightMargin: 6
    spacing: 10

    // Icon tile: filled when connected
    Rectangle {
      Layout.preferredWidth: 30
      Layout.preferredHeight: 30
      radius: 8
      color: root._connected
        ? (Config.darkMode ? Qt.rgba(1,1,1,0.14) : Qt.rgba(0,0,0,0.12))
        : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04))
      Behavior on color { CAnim {} }

      StyledText {
        anchors.centerIn: parent
        text: root._iconFor(root.device ? root.device.icon : "")
        font.pixelSize: Config.fontSize + 1
        color: root._connected ? root._fg : root._acc
        opacity: root._busy ? 0 : 1
        Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
      }

      // Busy spinner in place of the icon
      StyledText {
        anchors.centerIn: parent
        text: "󰑐"
        font.pixelSize: Config.fontSize
        color: root._fg
        opacity: root._busy ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
        RotationAnimation on rotation {
          running: root._busy
          loops: Animation.Infinite
          from: 0
          to: 360
          duration: 900
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 1

      StyledText {
        Layout.fillWidth: true
        text: root.device ? root.device.name : ""
        font.pixelSize: Config.fontSize - 2
        font.weight: root._connected ? Font.Medium : Font.Normal
        color: root._fg
        elide: Text.ElideRight
      }

      RowLayout {
        spacing: 6

        StyledText {
          text: root._busy ? BluetoothService.busyAction + "…"
              : root._connected ? "connected"
              : root._paired ? "paired" : "available"
          font.pixelSize: Config.fontSize - 5
          font.letterSpacing: 1.2
          color: root._busy ? root._fg : root._dim
        }

        // Battery, when the device reports it
        StyledText {
          visible: root._connected && root._battery >= 0
          text: root._batteryIcon(root._battery) + " " + root._battery + "%"
          font.pixelSize: Config.fontSize - 5
          color: root._battery <= 15
            ? (Config.darkMode ? ThemeDark.error : ThemeLight.error)
            : root._acc
        }
      }
    }

    // Hover action: disconnect when connected, forget when only paired.
    Item {
      visible: !root._busy && (root._connected || root._paired)
      opacity: ma.containsMouse || actionMa.containsMouse ? 1 : 0
      Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
      implicitWidth: 24
      implicitHeight: 24

      Rectangle {
        anchors.fill: parent
        radius: 6
        color: actionMa.containsMouse
          ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
          : "transparent"
        Behavior on color { CAnim {} }
      }
      StyledText {
        anchors.centerIn: parent
        text: root._connected ? "󰌸" : "󰩹"
        font.pixelSize: Config.fontSize - 1
        color: actionMa.containsMouse ? root._fg : root._acc
      }
      MouseArea {
        id: actionMa
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root._connected ? root.activated() : root.forgetRequested()
      }
    }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    enabled: !root._busy
    onClicked: root.activated()
    z: -1
  }
}
