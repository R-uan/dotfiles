import qs.config
import qs.shared
import qs.services

import QtQuick
import QtQuick.Layouts

// Current conditions on the left, the next three days on the right.
// Click to refetch.
Item {
  id: root
  implicitHeight: layout.implicitHeight

  readonly property color _fg:     Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _bright: Config.darkMode ? ThemeDark.foreground1 : ThemeLight.foreground1
  readonly property color _accent: Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color _dim:    Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3

  RowLayout {
    id: layout
    width: parent.width
    spacing: 12

    // ── Now ─────────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop
      spacing: 2

      RowLayout {
        spacing: 8

        StyledText {
          text: WeatherService.icon
          font.pixelSize: 26
          color: root._bright
        }
        StyledText {
          text: WeatherService.temp + "°"
          font.pixelSize: Config.fontSize + 10
          font.weight: Font.Medium
          color: root._bright
        }
      }

      StyledText {
        Layout.fillWidth: true
        text: WeatherService.description
        elide: Text.ElideRight
        font.pixelSize: Config.fontSize - 3
        color: root._fg
      }

      StyledText {
        Layout.fillWidth: true
        text: "feels " + WeatherService.feelsLike + "°  󰖎 " + WeatherService.humidity
              + "%  󰖝 " + WeatherService.wind
        elide: Text.ElideRight
        font.pixelSize: Config.fontSize - 4
        color: root._accent
      }

      StyledText {
        Layout.fillWidth: true
        visible: WeatherService.location.length > 0
        text: "󰍎 " + WeatherService.location
        elide: Text.ElideRight
        font.pixelSize: Config.fontSize - 5
        font.letterSpacing: 0.8
        color: root._dim
      }
    }

    // ── Forecast ────────────────────────────────────────
    Repeater {
      model: WeatherService.forecast

      ColumnLayout {
        required property var modelData
        Layout.alignment: Qt.AlignTop
        Layout.preferredWidth: 42
        spacing: 3

        StyledText {
          Layout.alignment: Qt.AlignHCenter
          text: modelData.day.toUpperCase()
          font.pixelSize: Config.fontSize - 6
          font.letterSpacing: 1.2
          color: root._dim
        }
        StyledText {
          Layout.alignment: Qt.AlignHCenter
          text: modelData.icon
          font.pixelSize: 18
          color: root._fg
        }
        StyledText {
          Layout.alignment: Qt.AlignHCenter
          text: modelData.max + "°"
          font.pixelSize: Config.fontSize - 3
          color: root._fg
        }
        StyledText {
          Layout.alignment: Qt.AlignHCenter
          text: modelData.min + "°"
          font.pixelSize: Config.fontSize - 4
          color: root._dim
        }
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: WeatherService.refresh()
  }
}
