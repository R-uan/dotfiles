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
  readonly property string textColor: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.background0

  Item {
    width: parent.width
    height: parent.height

    ColumnLayout {
      id: layout
      spacing: Config.spacing
      anchors.centerIn: parent
      width: parent.width - 10

      Background {
        radius: 36
        Layout.fillWidth: true
        color: ThemeDark.background2
        implicitHeight: innerLayout.implicitHeight + 20

        ColumnLayout {
          id: innerLayout
          width: parent.width
          anchors.centerIn: parent

          StyledText {
            color: root.textColor
            Layout.bottomMargin: -10
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Config.fontSize + 5
            text: Qt.formatDateTime(sysclock.date, "hh")
          }

          StyledText {
            color: root.textColor
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Config.fontSize + 5
            text: Qt.formatDateTime(sysclock.date, "mm")
          }
        }
      }
    }
  }
}
