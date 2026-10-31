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

  // Scroll and middle-click feedback comes from the OSD, which OsdService
  // raises on any PipeWire volume/mute change.
  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton

    onClicked: function (mouse) {
      if (mouse.button === Qt.MiddleButton) {
        AudioService.toggleMute();
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
    }
  }
}
