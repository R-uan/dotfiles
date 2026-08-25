import qs.shared
import qs.config

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: pb.height + 4

  Rectangle {
    anchors.centerIn: parent
    width: 32
    height: width
    radius: 8
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : "transparent"
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  StyledText {
    id: pb
    font.pixelSize: 20
    anchors.centerIn: parent
    text: "󰐥"
    color: mouseArea.containsMouse
      ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
      : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (powermenu.visible) {
        powermenu.visible = false;
        powermenu.timer.running = false;
        powermenu.armed = "";
      } else {
        powermenu.visible = true;
      }
    }
  }
}
