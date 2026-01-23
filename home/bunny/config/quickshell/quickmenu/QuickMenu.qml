import qs.shared
import qs.quickmenu

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

PanelWindow {
  id: quickMenu
  visible: false
  implicitHeight: 600
  color: "transparent"
  implicitWidth: 800
  objectName: "Status Bar Window"
  margins.top: Theme.barHeight + 5
  exclusionMode: ExclusionMode.Ignore

  property alias timer: timer

  // This is the main layout
  ColumnLayout {
    anchors.fill: parent
    // This is the top segment
    RowLayout {
      Layout.fillWidth: true
      Layout.preferredHeight: parent.height / 2

      Card {}
      DirectoryShortcut {}
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.preferredHeight: parent.height / 2

      Item {
        Layout.preferredHeight: 50
        Layout.preferredWidth: 210

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

      Rectangle {
        color: "transparent"
        border.color: "blue"
        border.width: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: false

    onTriggered: {
      quickMenu.visible = false;
    }
  }

  MouseArea {
    id: area
    hoverEnabled: true
    anchors.fill: parent
    propagateComposedEvents: true  // Add this line

    onExited: {
      timer.running = true;
    }

    onEntered: {
      timer.running = false;
      timer.interval = 1000;
    }
  }
}
