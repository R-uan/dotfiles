import qs.shared
import qs.config
import qs.services

import QtQuick

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: 26

  readonly property int _count: BluetoothService.connectedCount

  Rectangle {
    anchors.centerIn: parent
    width: 26
    height: width
    radius: 7
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : "transparent"
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  StyledText {
    id: icon
    anchors.centerIn: parent
    text: !BluetoothService.powered ? "󰂲"
        : root._count > 0 ? "󰂱"
        : "󰂯"
    font.pixelSize: 13
    color: !BluetoothService.powered
      ? (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
      : (mouseArea.containsMouse
          ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
          : (root._count > 0
              ? (Config.darkMode ? ThemeDark.success : ThemeLight.success)
              : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)))
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (bluetoothmenu.visible) {
        bluetoothmenu.visible = false;
        bluetoothmenu.timer.running = false;
      } else {
        bluetoothmenu.visible = true;
      }
    }
  }
}
