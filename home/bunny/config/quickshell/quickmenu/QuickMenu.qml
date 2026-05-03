import qs.shared
import qs.quickmenu
import qs.quickmenu.services
import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

PanelWindow {
  id: quickMenu
  visible: false
  color: "transparent"
  objectName: "Status Bar Window"
  exclusionMode: ExclusionMode.Ignore
  implicitWidth: mainLayout.implicitWidth
  implicitHeight: mainLayout.implicitHeight

  margins {
    top: Theme.barHeight + Theme.margins + 2
    left: Theme.margins + 15
  }

  property alias timer: timer

  // — Main layout —
  RowLayout {
    id: mainLayout
    anchors.top: parent.top
    anchors.left: parent.left
    spacing: 6

    // Column 1
    ColumnLayout {
      spacing: 6

      Card {
        Layout.preferredWidth: 240
        Layout.preferredHeight: 300
      }

      OpenWallpicker {
        Layout.preferredWidth: 240
        Layout.preferredHeight: 65
      }
    }

    // Column 2
    ColumnLayout {
      DirectoryShortcut {
        Layout.preferredWidth: 240
        Layout.preferredHeight: 370
      }
    }

    // Column 3
    ColumnLayout {
      spacing: 6

      Calendar {
        Layout.preferredWidth: 240
        Layout.preferredHeight: 295
      }

      Weather {
        Layout.preferredWidth: 240
        Layout.preferredHeight: 65
      }
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
