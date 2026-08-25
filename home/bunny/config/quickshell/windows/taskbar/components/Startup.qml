import qs.shared
import qs.config

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: (parent.width - nix.height) + 10

  Rectangle {
    anchors.centerIn: parent
    width: 28
    height: width
    radius: 8
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : "transparent"
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  MouseArea {
    id: mouseArea
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    anchors.fill: parent

    onClicked: {
      if (startmenu.visible) {
        startmenu.visible = false;
        startmenu.timer.running = false;
      } else {
        startmenu.visible = true;
      }
    }
  }

  StyledText {
    id: nix
    text: "󱄅"
    anchors.centerIn: parent
    font.pixelSize: Config.thickness * 0.55
  }
}
