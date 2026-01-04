import qs.shared
import qs.taskbar.sections

import QtQuick
import Quickshell

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
        left: true
        right: true
      }

      margins {
        bottom: -4
        top: Theme.margins
        left: Theme.margins + 15
        right: Theme.margins + 15
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
          right: parent.right
          verticalCenter: parent.verticalCenter
        }
      }
    }
  }
}
