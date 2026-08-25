import qs.shared
import qs.config
import QtQuick
import Quickshell
import QtQuick.Layouts

Item {
  id: root
  width: parent.width
  height: pill.implicitHeight + 8

  SystemClock {
    id: sysclock
    precision: SystemClock.Minutes
  }

  Rectangle {
    id: pill
    anchors.centerIn: parent
    width: parent.width - 8
    implicitHeight: innerLayout.implicitHeight + 14
    radius: 12
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.10))
      : (Config.darkMode ? Qt.rgba(1, 1, 1, 0.04) : Qt.rgba(0, 0, 0, 0.04))
    border.color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.15))
      : (Config.darkMode ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06))
    border.width: 1
    Behavior on color { ColorAnimation { duration: 120 } }

    ColumnLayout {
      id: innerLayout
      anchors.centerIn: parent
      spacing: -2

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(sysclock.date, "hh")
        font.pixelSize: Config.fontSize + 4
        font.weight: Font.Medium
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
      }

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(sysclock.date, "mm")
        font.pixelSize: Config.fontSize + 4
        font.weight: Font.Medium
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
      }

      Rectangle {
        Layout.topMargin: 4
        Layout.alignment: Qt.AlignHCenter
        width: 14
        height: 1
        color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.15)
      }

      StyledText {
        Layout.topMargin: 2
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(sysclock.date, "ddd").toUpperCase()
        font.pixelSize: Config.fontSize - 2
        font.letterSpacing: 1.2
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(sysclock.date, "dd")
        font.pixelSize: Config.fontSize
        font.weight: Font.Medium
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    propagateComposedEvents: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (startmenu.visible) {
        startmenu.visible = false;
        startmenu.timer.running = false;
      } else {
        startmenu.visible = true;
      }
    }
  }
}
