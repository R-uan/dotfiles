import qs.config
import qs.shared
import qs.services

import QtQuick

Item {
  id: root
  implicitWidth: parent ? parent.width : 28
  implicitHeight: 26

  Rectangle {
    anchors.centerIn: parent
    width: 26
    height: width
    radius: 7
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : "transparent"
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  StyledText {
    anchors.centerIn: parent
    text: SunsetService.icon
    font.pixelSize: 13
    color: !SunsetService.enabled
      ? (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
      : (mouseArea.containsMouse
          ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
          : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1))
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  // Temperature readout while scrolling, same as the audio button.
  Rectangle {
    id: bubble
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.top
    anchors.bottomMargin: 2
    width: bubbleText.implicitWidth + 10
    height: bubbleText.implicitHeight + 4
    radius: 4
    color: Config.darkMode ? ThemeDark.background2 : ThemeLight.background2
    border.color: Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.08)
    border.width: 1
    opacity: 0
    visible: opacity > 0.01

    StyledText {
      id: bubbleText
      anchors.centerIn: parent
      text: SunsetService.enabled ? SunsetService.temperature + "K" : "off"
      font.pixelSize: Config.fontSize - 4
      color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
    }

    Behavior on opacity { NumberAnimation { duration: 140 } }
  }

  Timer {
    id: bubbleTimer
    interval: 900
    onTriggered: bubble.opacity = 0
  }

  function _flashBubble() {
    bubble.opacity = 1;
    bubbleTimer.restart();
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton

    onClicked: function (mouse) {
      if (mouse.button === Qt.MiddleButton) {
        SunsetService.toggle();
        root._flashBubble();
        return;
      }
      if (sunsetmenu.visible) {
        sunsetmenu.visible = false;
        sunsetmenu.timer.running = false;
      } else {
        sunsetmenu.visible = true;
      }
    }

    onWheel: function (wheel) {
      SunsetService.stepTemperature(wheel.angleDelta.y > 0 ? 250 : -250);
      root._flashBubble();
    }
  }
}
