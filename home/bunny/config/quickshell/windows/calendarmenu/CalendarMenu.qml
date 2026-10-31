import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

// Opens beside the clock: anchored only to the left edge, so the layer
// shell centres it vertically, which is where the clock sits on the bar.
PanelWindow {
  id: calendarMenu
  visible: false
  implicitWidth: 320
  implicitHeight: layout.implicitHeight + 28
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

  readonly property bool _showWeather: Config.weatherEnabled && WeatherService.ready

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

  ColumnLayout {
    id: layout
    x: 14
    y: 14
    width: parent.width - 28
    spacing: 12

    // Calendar content is ~210px (header + weekday row + 6-week grid).
    Calendar {
      Layout.fillWidth: true
      Layout.preferredHeight: 216
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      visible: calendarMenu._showWeather
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    WeatherCard {
      Layout.fillWidth: true
      visible: calendarMenu._showWeather
    }
  }
}
