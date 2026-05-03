import qs.shared
import qs.quickmenu

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

Item {
  SolidBackground {
    anchors.fill: parent
  }

  CommonText {
    text: ""
    font.pixelSize: 22
    color: Theme.foreground
    anchors.centerIn: parent
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onClicked: {
      if (wallpicker.visible) {
        wallpicker.visible = false;
        wallpicker.timer.running = false;
      } else {
        wallpicker.visible = true;
        mouse.accepted = true;  // Add this to prevent propagation
        // quickMenu.timer.interval = 2000;
        // quickMenu.timer.running = true;
      }
    }
  }
}
