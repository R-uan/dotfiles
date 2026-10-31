import qs.shared
import qs.config
import qs.services
import "../audiomenu"

import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
  id: sunsetMenu
  visible: false
  implicitWidth: 300
  color: "transparent"
  objectName: "Sunset Menu"
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
    onTriggered: sunsetMenu.visible = false
  }

  HoverHandler {
    onHoveredChanged: {
      if (hovered) timer.stop();
      else         timer.restart();
    }
  }

  readonly property color _fg:     Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _accent: Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color _dim:    Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _muted:  Config.darkMode ? ThemeDark.muted       : ThemeLight.muted
  readonly property color _line:   Config.darkMode ? Qt.rgba(1,1,1,0.07)   : Qt.rgba(0,0,0,0.07)

  readonly property var _presets: [
    { label: "6500K", temp: 6500 },
    { label: "4500K", temp: 4500 },
    { label: "3500K", temp: 3500 },
    { label: "2500K", temp: 2500 }
  ]

  // VolumeSlider works in 0-100, so map the hyprsunset ranges onto that.
  function _tempToPct(t) {
    return Math.round((t - SunsetService.minTemp) / (SunsetService.maxTemp - SunsetService.minTemp) * 100);
  }
  function _pctToTemp(p) {
    return SunsetService.minTemp + p / 100 * (SunsetService.maxTemp - SunsetService.minTemp);
  }
  function _gammaToPct(g) {
    return Math.round((g - SunsetService.minGamma) / (SunsetService.maxGamma - SunsetService.minGamma) * 100);
  }
  function _pctToGamma(p) {
    return SunsetService.minGamma + p / 100 * (SunsetService.maxGamma - SunsetService.minGamma);
  }

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
        text: SunsetService.icon
        font.pixelSize: Config.fontSize + 4
        color: SunsetService.enabled ? sunsetMenu._accent : sunsetMenu._muted
      }
      StyledText {
        text: "Night Light"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: sunsetMenu._accent
      }
      Item { Layout.fillWidth: true }

      // On/off toggle
      Item {
        Layout.preferredWidth: 24
        Layout.preferredHeight: 24

        Rectangle {
          anchors.fill: parent
          radius: 6
          color: toggleMa.containsMouse
            ? (Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.06))
            : "transparent"
          Behavior on color { ColorAnimation { duration: 110 } }
        }
        StyledText {
          anchors.centerIn: parent
          text: SunsetService.enabled ? "󰔡" : "󰨙"
          font.pixelSize: Config.fontSize + 2
          color: SunsetService.enabled ? sunsetMenu._fg : sunsetMenu._muted
        }
        MouseArea {
          id: toggleMa
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: SunsetService.toggle()
        }
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: sunsetMenu._line
    }

    // ── Temperature ───────────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6

      StyledText {
        text: "TEMPERATURE"
        font.pixelSize: Config.fontSize - 5
        font.letterSpacing: 1.4
        color: sunsetMenu._dim
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 10

        VolumeSlider {
          Layout.fillWidth: true
          value: sunsetMenu._tempToPct(SunsetService.temperature)
          dimmed: !SunsetService.enabled
          onMoved: v => SunsetService.setTemperature(sunsetMenu._pctToTemp(v))
        }

        StyledText {
          Layout.preferredWidth: 44
          text: SunsetService.temperature + "K"
          font.pixelSize: Config.fontSize - 4
          color: SunsetService.enabled ? sunsetMenu._fg : sunsetMenu._muted
          horizontalAlignment: Text.AlignRight
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 6

        Repeater {
          model: sunsetMenu._presets
          Item {
            required property var modelData
            readonly property bool _active: SunsetService.enabled && SunsetService.temperature === modelData.temp
            Layout.fillWidth: true
            implicitHeight: 24

            Rectangle {
              anchors.fill: parent
              radius: 6
              color: parent._active
                ? (Config.darkMode ? Qt.rgba(1,1,1,0.14) : Qt.rgba(0,0,0,0.10))
                : (presetMa.containsMouse
                    ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
                    : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04)))
              border.color: Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.08)
              border.width: 1
              Behavior on color { ColorAnimation { duration: 110 } }
            }
            StyledText {
              anchors.centerIn: parent
              text: modelData.label
              font.pixelSize: Config.fontSize - 5
              font.letterSpacing: 1.2
              color: sunsetMenu._fg
            }
            MouseArea {
              id: presetMa
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: SunsetService.setTemperature(modelData.temp)
            }
          }
        }
      }
    }

    // ── Gamma ─────────────────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6

      StyledText {
        text: "GAMMA"
        font.pixelSize: Config.fontSize - 5
        font.letterSpacing: 1.4
        color: sunsetMenu._dim
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 10

        VolumeSlider {
          Layout.fillWidth: true
          value: sunsetMenu._gammaToPct(SunsetService.gamma)
          onMoved: v => SunsetService.setGamma(sunsetMenu._pctToGamma(v))
        }

        StyledText {
          Layout.preferredWidth: 44
          text: SunsetService.gamma + "%"
          font.pixelSize: Config.fontSize - 4
          color: sunsetMenu._fg
          horizontalAlignment: Text.AlignRight
        }
      }
    }
  }
}
