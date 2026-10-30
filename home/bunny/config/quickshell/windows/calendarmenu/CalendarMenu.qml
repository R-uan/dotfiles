import qs.shared
import qs.config

import QtQuick
import Quickshell

// Opens beside the clock: anchored only to the left edge, so the layer
// shell centres it vertically, which is where the clock sits on the bar.
PanelWindow {
  id: calendarMenu
  visible: false
  implicitWidth: 320
  // Calendar content is ~210px (header + weekday row + 6-week grid) + margins.
  implicitHeight: 244
  color: "transparent"
  objectName: "Calendar Menu"
  exclusionMode: ExclusionMode.Normal

  anchors {
    left: true
    top: false
    bottom: false
    right: false
  }

  margins {
    left: 6
  }

  Background {
    radius: 14
  }

  property alias timer: timer

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: calendarMenu.visible = false
  }

  HoverHandler {
    onHoveredChanged: {
      if (hovered) timer.stop();
      else         timer.restart();
    }
  }

  Calendar {
    anchors.fill: parent
    anchors.margins: 14
  }
}
