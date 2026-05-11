import qs.shared
import qs.config

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: (parent.width - nix.height) + 10

  MouseArea {
    id: mouseArea
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
    font.pixelSize: Config.thickness * 0.7
  }
}
