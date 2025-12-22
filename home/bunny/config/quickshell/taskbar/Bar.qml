import qs
import qs.taskbar.shared
import qs.taskbar.sections
import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: mainWindow
      visible: true
      color: "transparent"
      implicitWidth: Theme.barWidth
      implicitHeight: Theme.barHeight
      objectName: "Status Bar Window"

      screen: modelData
      property var modelData

      anchors {
        top: true
      }

      margins {
        bottom: -4
        top: Theme.margins
        left: Theme.margins
        right: Theme.margins
      }

      Rectangle {
        border.width: 2
        anchors.fill: parent
        color: Theme.background
        topLeftRadius: Theme.radius
        topRightRadius: Theme.radius
        bottomLeftRadius: Theme.radius
        bottomRightRadius: Theme.radius
        border.color: Theme.borderColour
        opacity: Theme.backgroundOpacity
      }

      // ---- LEFT ----
      LeftSection {
        id: left
        height: parent.height

        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
        }
      }

      // ---- CENTER ----
      MiddleSection {
        id: middle
        height: parent.height

        anchors {
          verticalCenter: parent.verticalCenter
          horizontalCenter: parent.horizontalCenter
        }
      }

      // ---- RIGHT ----
      RightSection {
        id: right
        height: parent.height

        anchors {
          rightMargin: 10
          right: parent.right
          verticalCenter: parent.verticalCenter
        }
      }
    }
  }
}
