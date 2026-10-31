import qs.config
import qs.shared
import qs.services

import QtQuick

// Shown only while recording: a pulsing dot over the elapsed time.
// Click to stop.
Item {
  id: root
  implicitWidth: parent ? parent.width : 28
  implicitHeight: RecorderService.recording ? 36 : 0
  visible: implicitHeight > 0
  clip: true

  Behavior on implicitHeight { Anim { duration: Motion.fastSpatialDuration } }

  Rectangle {
    anchors.centerIn: parent
    width: 34
    height: 32
    radius: 8
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04))
    Behavior on color { CAnim {} }
  }

  Column {
    anchors.centerIn: parent
    spacing: 3

    Rectangle {
      id: dot
      anchors.horizontalCenter: parent.horizontalCenter
      width: 8
      height: 8
      radius: 4
      color: mouseArea.containsMouse
        ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
        : (Config.darkMode ? ThemeDark.error : ThemeLight.error)

      SequentialAnimation on opacity {
        running: RecorderService.recording
        loops: Animation.Infinite
        NumberAnimation { to: 0.25; duration: 700; easing.type: Easing.InOutSine }
        NumberAnimation { to: 1; duration: 700; easing.type: Easing.InOutSine }
      }
    }

    StyledText {
      anchors.horizontalCenter: parent.horizontalCenter
      text: mouseArea.containsMouse ? "stop" : RecorderService.elapsedText
      font.pixelSize: 9
      color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: RecorderService.stop()
  }
}
