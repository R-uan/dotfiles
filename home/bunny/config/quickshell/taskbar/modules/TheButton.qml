import qs.shared

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
      if (quickMenu.visible) {
        quickMenu.visible = false;
        quickMenu.timer.running = false;
      } else {
        quickMenu.visible = true;
        // quickMenu.timer.interval = 2000;
        // quickMenu.timer.running = true;
      }
    }
  }

  CommonText {
    id: nix
    text: "󱄅"
    font.pixelSize: 27
    color: Theme.foreground
    anchors.centerIn: parent
  }
}
