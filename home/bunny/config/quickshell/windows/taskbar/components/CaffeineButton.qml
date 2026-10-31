import qs.config
import qs.shared
import qs.services

import QtQuick

// Only shown while caffeine is on (toggle it from the start menu), so the
// bar says why the screen isn't locking. Click to turn it off.
Item {
  id: root
  implicitWidth: parent ? parent.width : 28
  implicitHeight: IdleService.inhibited ? 26 : 0
  visible: implicitHeight > 0
  clip: true

  Behavior on implicitHeight { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

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
    text: IdleService.icon
    font.pixelSize: 13
    color: mouseArea.containsMouse
      ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
      : (Config.darkMode ? ThemeDark.warning : ThemeLight.warning)
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: IdleService.toggle()
  }
}
