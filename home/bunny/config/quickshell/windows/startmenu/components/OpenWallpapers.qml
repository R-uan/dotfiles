import qs.shared
import qs.config

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

Item {
  Background {
    anchors.fill: parent
  }

  StyledText {
    text: ""
    font.pixelSize: 22
    color: Theme.foreground
    anchors.centerIn: parent
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onClicked: {
      if (wallpapers.visible) {
        wallpapers.visible = false;
        wallpapers.timer.running = false;
      } else {
        wallpapers.visible = true;
        // quickMenu.timer.interval = 2000;
        // quickMenu.timer.running = true;
      }
    }
  }
}
