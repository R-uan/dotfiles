import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
  id: audioMenu
  visible: false
  implicitWidth: 340
  color: "transparent"
  objectName: "Audio Menu"
  implicitHeight: mainLayout.implicitHeight + 28
  exclusionMode: ExclusionMode.Normal

  anchors {
    bottom: true
    left: true
    right: false
    top: false
  }

  margins {
    bottom: 6
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
    onTriggered: audioMenu.visible = false
  }

  HoverHandler {
    onHoveredChanged: {
      if (hovered) timer.stop();
      else         timer.restart();
    }
  }

  readonly property color _fg:    Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _accent: Config.darkMode ? ThemeDark.primary1   : ThemeLight.primary1
  readonly property color _dim:   Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _muted: Config.darkMode ? ThemeDark.muted       : ThemeLight.muted
  readonly property color _line:  Config.darkMode ? Qt.rgba(1,1,1,0.07)   : Qt.rgba(0,0,0,0.07)

  ColumnLayout {
    id: mainLayout
    spacing: 10
    width: parent.width - 28
    x: 14
    y: 14

    // ── Header ────────────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      StyledText {
        text: AudioService.icon
        font.pixelSize: Config.fontSize + 4
        color: AudioService.muted ? audioMenu._muted : audioMenu._accent
      }
      StyledText {
        text: "Audio"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: audioMenu._accent
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: AudioService.muted ? "muted" : AudioService.volume + "%"
        font.pixelSize: Config.fontSize - 4
        font.letterSpacing: 1.4
        color: AudioService.muted ? audioMenu._muted : audioMenu._dim
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: audioMenu._line
    }

    // ── Output ────────────────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6

      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        StyledText {
          text: "OUTPUT"
          font.pixelSize: Config.fontSize - 5
          font.letterSpacing: 1.4
          color: audioMenu._dim
        }
        StyledText {
          Layout.fillWidth: true
          text: AudioService.sinkName
          font.pixelSize: Config.fontSize - 4
          color: audioMenu._dim
          horizontalAlignment: Text.AlignRight
          elide: Text.ElideRight
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 10

        // Mute toggle
        Item {
          Layout.preferredWidth: 24
          Layout.preferredHeight: 24

          Rectangle {
            anchors.fill: parent
            radius: 6
            color: muteMa.containsMouse
              ? (Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.06))
              : "transparent"
            Behavior on color { ColorAnimation { duration: 110 } }
          }
          StyledText {
            anchors.centerIn: parent
            text: AudioService.icon
            font.pixelSize: Config.fontSize
            color: AudioService.muted ? audioMenu._muted : audioMenu._fg
          }
          MouseArea {
            id: muteMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: AudioService.toggleMute()
          }
        }

        VolumeSlider {
          Layout.fillWidth: true
          value: AudioService.volume
          dimmed: AudioService.muted
          onMoved: v => AudioService.setVolume(v)
        }

        StyledText {
          Layout.preferredWidth: 34
          text: AudioService.volume + "%"
          font.pixelSize: Config.fontSize - 4
          color: audioMenu._fg
          horizontalAlignment: Text.AlignRight
        }
      }
    }

    // ── Input ─────────────────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6
      visible: AudioService.source !== null

      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        StyledText {
          text: "INPUT"
          font.pixelSize: Config.fontSize - 5
          font.letterSpacing: 1.4
          color: audioMenu._dim
        }
        StyledText {
          Layout.fillWidth: true
          text: AudioService.sourceName
          font.pixelSize: Config.fontSize - 4
          color: audioMenu._dim
          horizontalAlignment: Text.AlignRight
          elide: Text.ElideRight
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Item {
          Layout.preferredWidth: 24
          Layout.preferredHeight: 24

          Rectangle {
            anchors.fill: parent
            radius: 6
            color: micMa.containsMouse
              ? (Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.06))
              : "transparent"
            Behavior on color { ColorAnimation { duration: 110 } }
          }
          StyledText {
            anchors.centerIn: parent
            text: AudioService.micIcon
            font.pixelSize: Config.fontSize
            color: AudioService.micMuted ? audioMenu._muted : audioMenu._fg
          }
          MouseArea {
            id: micMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: AudioService.toggleMicMute()
          }
        }

        VolumeSlider {
          Layout.fillWidth: true
          value: AudioService.micVolume
          dimmed: AudioService.micMuted
          onMoved: v => AudioService.setMicVolume(v)
        }

        StyledText {
          Layout.preferredWidth: 34
          text: AudioService.micVolume + "%"
          font.pixelSize: Config.fontSize - 4
          color: audioMenu._fg
          horizontalAlignment: Text.AlignRight
        }
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: audioMenu._line
      visible: AudioService.sinks.length > 1
    }

    // ── Output device picker ──────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2
      visible: AudioService.sinks.length > 1

      StyledText {
        text: "DEVICES"
        font.pixelSize: Config.fontSize - 5
        font.letterSpacing: 1.4
        color: audioMenu._dim
        Layout.bottomMargin: 2
      }

      Repeater {
        model: AudioService.sinks
        AudioDeviceRow {
          required property var modelData
          Layout.fillWidth: true
          node: modelData
          active: AudioService.sink === modelData
          onActivated: AudioService.setSink(modelData)
        }
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: audioMenu._line
      visible: AudioService.streams.length > 0
    }

    // ── Per-application streams ───────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 8
      visible: AudioService.streams.length > 0

      StyledText {
        text: "PLAYING"
        font.pixelSize: Config.fontSize - 5
        font.letterSpacing: 1.4
        color: audioMenu._dim
      }

      Repeater {
        model: AudioService.streams

        ColumnLayout {
          required property var modelData
          Layout.fillWidth: true
          spacing: 4

          RowLayout {
            Layout.fillWidth: true
            spacing: 8

            StyledText {
              Layout.fillWidth: true
              text: AudioService.nodeLabel(modelData)
              font.pixelSize: Config.fontSize - 4
              color: audioMenu._fg
              elide: Text.ElideRight
            }
            StyledText {
              text: modelData.audio
                ? Math.round(modelData.audio.volume * 100) + "%"
                : ""
              font.pixelSize: Config.fontSize - 5
              color: audioMenu._dim
            }
          }

          VolumeSlider {
            Layout.fillWidth: true
            value: modelData.audio ? Math.round(modelData.audio.volume * 100) : 0
            dimmed: modelData.audio ? modelData.audio.muted : false
            onMoved: v => AudioService.setStreamVolume(modelData, v)
          }
        }
      }
    }
  }
}
