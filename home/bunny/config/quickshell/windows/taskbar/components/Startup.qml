import qs.shared
import qs.config

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  Layout.alignment: Qt.AlignVCenter
  Layout.preferredHeight: parent.height
  Layout.preferredWidth: nix.width + (parent.height - nix.width)

  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onClicked: {
      if (startmenu.visible) {
        startmenu.visible = false;
        startmenu.timer.running = false;
      } else {
        startmenu.visible = true;
        // startmenu.timer.interval = 2000;
        // startmenu.timer.running = true;
      }
    }
  }

  StyledText {
    id: nix
    text: "󱄅"
    color: Theme.foreground
    anchors.centerIn: parent
    font.pixelSize: Theme.barHeight * 0.8
  }
}
