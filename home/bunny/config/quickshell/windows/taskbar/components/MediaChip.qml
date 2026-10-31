import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Effects

// Round album art wrapped in a track-progress ring. Grayscale at rest,
// colour on hover. Click: play/pause · scroll: next/previous · right click:
// open the start menu, which has the full player.
Item {
  id: root
  implicitWidth: parent ? parent.width : 40
  implicitHeight: MediaService.hasPlayer ? 40 : 0
  visible: implicitHeight > 0
  clip: true

  Behavior on implicitHeight { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

  readonly property bool _playing: MediaService.player?.isPlaying ?? false
  readonly property string _art: MediaService.player?.trackArtUrl ?? ""

  Ring {
    id: ring
    anchors.centerIn: parent
    width: 36
    height: 36
    strokeWidth: 2
    value: MediaService.progress
    fillColor: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
    trackColor: Config.darkMode ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.10)
  }

  Item {
    id: artBox
    anchors.centerIn: parent
    width: 28
    height: 28

    Rectangle {
      anchors.fill: parent
      radius: width / 2
      color: Config.darkMode ? ThemeDark.background2 : ThemeLight.background2
    }

    StyledText {
      anchors.centerIn: parent
      visible: art.status !== Image.Ready
      text: "󰝚"
      font.pixelSize: 13
      color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
    }

    Image {
      id: art
      anchors.fill: parent
      source: root._art
      sourceSize.width: 64
      sourceSize.height: 64
      fillMode: Image.PreserveAspectCrop
      asynchronous: true
      visible: false
    }

    MultiEffect {
      anchors.fill: parent
      source: art
      visible: art.status === Image.Ready
      maskEnabled: true
      maskSource: artMask
      saturation: mouseArea.containsMouse ? 0 : -1
      brightness: root._playing ? 0 : -0.25
      Behavior on saturation { NumberAnimation { duration: 200 } }
      Behavior on brightness { NumberAnimation { duration: 200 } }
    }

    Item {
      id: artMask
      anchors.fill: parent
      layer.enabled: true
      visible: false
      Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "black"
      }
    }

    // Play/pause hint while hovering or paused.
    Rectangle {
      anchors.fill: parent
      radius: width / 2
      color: Qt.rgba(0, 0, 0, 0.45)
      opacity: mouseArea.containsMouse || !root._playing ? 1 : 0
      Behavior on opacity { NumberAnimation { duration: 140 } }

      StyledText {
        anchors.centerIn: parent
        text: root._playing ? "󰏤" : "󰐊"
        font.pixelSize: 13
        color: Qt.rgba(1, 1, 1, 0.92)
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    property real _wheelAcc: 0

    onClicked: function (mouse) {
      if (mouse.button === Qt.RightButton) {
        startmenu.visible = !startmenu.visible;
        return;
      }
      if (mouse.button === Qt.MiddleButton) {
        MediaService.next();
        return;
      }
      MediaService.togglePlaying();
    }

    // Accumulate so a touchpad flick skips one track, not ten.
    onWheel: function (wheel) {
      _wheelAcc += wheel.angleDelta.y;
      if (_wheelAcc >= 120)       { MediaService.previous(); _wheelAcc = 0; }
      else if (_wheelAcc <= -120) { MediaService.next();     _wheelAcc = 0; }
    }
  }
}
