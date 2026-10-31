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

  // Temperature feedback through the OSD, like the audio button. The bar is
  // drawn reversed (warmer = fuller) since that's what "more night light" means.
  function _flashOsd() {
    const span = SunsetService.maxTemp - SunsetService.minTemp;
    OsdService.show(SunsetService.icon, "Night light",
                    (SunsetService.maxTemp - SunsetService.temperature) / span,
                    SunsetService.enabled ? SunsetService.temperature + "K" : "off",
                    !SunsetService.enabled);
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
        root._flashOsd();
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
      root._flashOsd();
    }
  }
}
