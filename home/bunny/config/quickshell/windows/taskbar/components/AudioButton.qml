import qs.config
import qs.shared
import qs.services

import QtQuick

Item {
  id: root
  implicitWidth: parent ? parent.width : 28
  implicitHeight: 26

  readonly property bool _silent: AudioService.muted || AudioService.volume <= 0

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
    text: AudioService.icon
    font.pixelSize: 13
    color: root._silent
      ? (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
      : (mouseArea.containsMouse
          ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
          : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1))
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  // Volume readout that fades in while scrolling, so the wheel gesture has
  // feedback without needing the menu open.
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
      text: AudioService.muted ? "muted" : AudioService.volume + "%"
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
        AudioService.toggleMute();
        root._flashBubble();
        return;
      }
      if (audiomenu.visible) {
        audiomenu.visible = false;
        audiomenu.timer.running = false;
      } else {
        audiomenu.visible = true;
      }
    }

    onWheel: function (wheel) {
      AudioService.stepVolume(wheel.angleDelta.y > 0 ? 5 : -5);
      root._flashBubble();
    }
  }
}
