import qs.shared
import qs.config
import QtQuick
import Quickshell
import QtQuick.Layouts

Item {
  id: root
  width: parent.width
  height: layout.implicitHeight + 10

  SystemClock {
    id: sysclock
    precision: SystemClock.Seconds
  }

  readonly property string accentColor: Config.darkMode ? ThemeDark.colour6 : ThemeLight.primary3
  readonly property string textColor:   Config.darkMode ? ThemeDark.background0 : ThemeLight.background0

  ColumnLayout {
    id: layout
    spacing: Config.spacing
    anchors.centerIn: parent
    implicitWidth: parent.width
    Layout.alignment: Qt.AlignHCenter

    // Time
    ColumnLayout {
      id: time
      spacing: 0
      implicitWidth: parent.width - 8
      Layout.alignment: Qt.AlignHCenter

      Background {
        anchors.fill: parent
        color: root.accentColor
      }

      Item {
        height: parent.width
        Layout.bottomMargin: -10
        width: parent.implicitWidth

        StyledText {
          color: root.textColor
          anchors.centerIn: parent
          Layout.alignment: Qt.AlignHCenter
          font.pixelSize: Config.fontSize + 5
          text: Qt.formatDateTime(sysclock.date, "hh")
        }
      }

      Item {
        Layout.topMargin: -10
        height: parent.width
        width: parent.implicitWidth

        StyledText {
          anchors.centerIn: parent
          Layout.alignment: Qt.AlignHCenter
          font.pixelSize: Config.fontSize + 5
          text: Qt.formatDateTime(sysclock.date, "mm")
          color: root.textColor
        }
      }
    }

    // Date
    ColumnLayout {
      spacing: 0
      implicitWidth: parent.width - 8
      Layout.alignment: Qt.AlignHCenter

      Background {
        anchors.fill: parent
        color: root.accentColor
      }

      Item {
        Layout.bottomMargin: -12
        height: parent.width
        width: parent.implicitWidth

        StyledText {
          color: root.textColor
          anchors.centerIn: parent
          Layout.alignment: Qt.AlignHCenter
          font.pixelSize: Config.fontSize + 0
          text: Qt.formatDateTime(sysclock.date, "ddd")
        }
      }

      Item {
        Layout.topMargin: -9
        Layout.bottomMargin: -8
        height: parent.width
        width: parent.implicitWidth

        StyledText {
          color: root.textColor
          anchors.centerIn: parent
          Layout.alignment: Qt.AlignHCenter
          font.pixelSize: Config.fontSize + 5
          text: Qt.formatDateTime(sysclock.date, "dd")
        }
      }

      Item {
        Layout.topMargin: -15
        height: parent.width
        width: parent.implicitWidth

        StyledText {
          color: root.textColor
          anchors.centerIn: parent
          font.pixelSize: Config.fontSize + 0
          Layout.alignment: Qt.AlignHCenter
          text: Qt.formatDateTime(sysclock.date, "MMM")
        }
      }
    }
  }
}
