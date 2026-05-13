import qs.shared
import qs.config
import qs.services
import qs.windows.startmenu.components

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

PanelWindow {
  id: quickMenu
  visible: true 
  color: "transparent"
  objectName: "Start Menu"
  exclusionMode: ExclusionMode.Normal
  implicitWidth: 500 
  implicitHeight: mainLayout.implicitHeight
  
  
  anchors {
      top: true
      left: true
      right: false
  }

  margins {
    top: 4
    left: 4
  }

  Background {
    radius: 12
  }

  property alias timer: timer
  
  ColumnLayout {
    id: mainLayout
    spacing: 0
    implicitWidth: parent.width

    // Column 
    RowLayout {
      spacing: 6
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredWidth: quickMenu.width

      Card {
        Layout.margins: 10
        Layout.preferredHeight: 150 
        Layout.preferredWidth: quickMenu.width - 20
      }
    }
  
    ColumnLayout {
      HomeShortcut {
        Layout.preferredWidth: quickMenu.width 
      }
    }

    // Column 2
    RowLayout {
      Layout.alignment: Qt.AlignVCenter

      ColumnLayout {
        spacing:0 

        Calendar {
          Layout.preferredWidth: 240
          Layout.preferredHeight: 295
        }

        Weather {
          Layout.preferredWidth: 240
          Layout.preferredHeight: 65
        }
      }


      MediaPlayer {
        Layout.preferredWidth: 240
        Layout.preferredHeight: 360
      }
    }

    // Column 3
    ColumnLayout {
      spacing: 6
      Layout.alignment: Qt.AlignVCenter
      OpenWallpapers {
        Layout.preferredWidth: 240
        Layout.preferredHeight: 65
      }

    }

    // Column 4
    ColumnLayout {
      Layout.alignment: Qt.AlignVCenter
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: quickMenu.visible = false
  }

  MouseArea {
    id: area
    hoverEnabled: true
    anchors.fill: parent
    propagateComposedEvents: true
    onExited: timer.running = true
    onEntered: {
      timer.running = false;
      timer.interval = 1000;
    }
  }
}
