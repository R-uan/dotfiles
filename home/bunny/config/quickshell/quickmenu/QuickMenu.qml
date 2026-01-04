import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts
import qs
import qs.taskbar
import qs.taskbar.shared
import qs.taskbar.modules

PanelWindow {
  id: quickMenu
  visible: false
  implicitHeight: 350
  color: "transparent"
  implicitWidth: Theme.barWidth
  objectName: "Status Bar Window"
  margins.top: Theme.barHeight + 7
  exclusionMode: ExclusionMode.Ignore

  property alias timer: timer

  anchors {
    top: true
  }

  RowLayout {
    anchors.fill: parent

    Item {
      Layout.fillHeight: true
      Layout.preferredWidth: 250

      ColumnLayout {
        anchors.centerIn: parent

        Item {
          Layout.preferredWidth: 220
          Layout.preferredHeight: 220

          Image {
            id: img
            visible: false
            anchors.fill: parent
            source: "cardimg.jpg"
          }

          MultiEffect {
            source: img
            anchors.fill: img
            maskEnabled: true
            maskSource: mask
          }

          // Rectangle {
          //   radius: 17
          //   border.width: 1
          //   anchors.fill: parent
          //   color: "transparent"
          //   border.color: Theme.borderColour
          // }

          Item {
            id: mask
            width: img.width
            height: img.height
            layer.enabled: true
            visible: false

            Rectangle {
              radius: 17
              color: "black"
              width: img.width
              height: img.height
            }
          }
        }

        CommonText {
          Layout.topMargin: 15
          Layout.alignment: Qt.AlignHCenter
          font.pixelSize: Theme.fontSize + 7
          text: "ForgetfulBnnuy"
          font.weight: 900
        }

        CommonText {
          Layout.alignment: Qt.AlignHCenter
          font.pixelSize: Theme.fontSize + 4
          font.weight: 400
          text: "ruan"
        }
      }

      Rectangle {
        z: -1
        border.width: 2
        radius: Theme.radius
        anchors.fill: parent
        color: Theme.background
        border.color: Theme.borderColour
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

    onExited: {
      timer.running = true;
    }

    onEntered: {
      timer.running = false;
      timer.interval = 1000;
    }
  }

  Rectangle {
    // border.width: 2
    anchors.fill: parent
    color: "transparent" // Theme.background
    topLeftRadius: Theme.radius
    topRightRadius: Theme.radius
    bottomLeftRadius: Theme.radius
    bottomRightRadius: Theme.radius
    // border.color: Theme.borderColour
    opacity: Theme.backgroundOpacity
  }
}
