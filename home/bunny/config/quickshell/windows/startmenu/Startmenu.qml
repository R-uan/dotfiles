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
  visible: false
  implicitWidth: 500
  color: "transparent"
  objectName: "Start Menu"
  exclusionMode: ExclusionMode.Normal
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
    width: parent.width          // width, not implicitWidth

    RowLayout {
      spacing: 6
      Layout.fillWidth: true   // fill instead of referencing quickMenu.width

      Card {
        Layout.margins: 10
        Layout.preferredHeight: 150
        Layout.fillWidth: true
      }
    }

    HomeShortcut {
      Layout.fillWidth: true   // removed pointless ColumnLayout wrapper
    }

    MediaPlayer {
      Layout.preferredHeight: 200
      Layout.fillWidth: true
    }

    RowLayout {
      spacing: 0
      Layout.fillWidth: true
      Calendar {
        Layout.preferredHeight: 295
        Layout.fillWidth: true  // let the layout distribute width
      }

      Weather {
        Layout.rightMargin: 5
        Layout.preferredWidth: 100
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
