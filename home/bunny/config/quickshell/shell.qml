//@ pragma UseQApplication

import QtQuick
import "taskbar"
import "wallpicker"
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import qs.taskbar.modules

ShellRoot {
  Bar {
    id: bar
  }

  PanelWindow {
    id: menu
    visible: false

    margins.top: 40
    implicitHeight: 170
    implicitWidth: 1000
    color: "transparent"
    objectName: "Status Bar Window"
    exclusionMode: ExclusionMode.Ignore

    anchors {
      top: true
    }

    property alias timer: timer

    Timer {
      id: timer
      interval: 1000
      running: false

      onTriggered: {
        menu.visible = false;
      }
    }

    MouseArea {
      id: area
      hoverEnabled: true
      anchors.fill: parent

      onExited: {
        timer.running = true;
      }

      onEntered: {
        timer.running = false;
        timer.interval = 1000;
      }
    }

    Rectangle {
      radius: 6
      anchors.fill: parent
      color: Theme.background
      border.color: Theme.borderColour
      border.width: 1
    }

    RowLayout {
      anchors.fill: parent

      Item {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: layout.width
        Layout.preferredHeight: layout.height

        RowLayout {
          id: layout

          Network {}
          Network {}
          Network {}
        }
      }
    }
  }
}
