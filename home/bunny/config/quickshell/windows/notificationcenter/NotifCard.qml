import qs.shared
import qs.config

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  property var notif
  property bool isActive: true
  signal dismiss()

  implicitHeight: card.implicitHeight

  readonly property string _summary: (notif && notif.summary) ? String(notif.summary) : ""
  readonly property string _body:    (notif && notif.body)    ? String(notif.body)    : ""
  readonly property string _app:     (notif && notif.app_name) ? String(notif.app_name) : ""
  readonly property string _urg:     (notif && notif.urgency) ? String(notif.urgency) : "normal"

  readonly property color _accent: {
    if (_urg === "critical" || _urg === "high")
      return Config.darkMode ? ThemeDark.error : ThemeLight.error;
    if (_urg === "low")
      return Config.darkMode ? ThemeDark.muted : ThemeLight.muted;
    return Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1;
  }

  Rectangle {
    id: card
    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: content.implicitHeight + 16
    radius: 8
    color: Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04)
    border.color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
    border.width: 1

    // Left accent stripe
    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: 3
      radius: 8
      color: root._accent
      opacity: root.isActive ? 0.9 : 0.35
    }

    ColumnLayout {
      id: content
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.leftMargin: 12
      anchors.rightMargin: 8
      anchors.topMargin: 8
      spacing: 2

      RowLayout {
        Layout.fillWidth: true
        spacing: 6

        StyledText {
          text: root._app.length > 0 ? root._app : "notification"
          font.pixelSize: Config.fontSize - 4
          font.letterSpacing: 1.2
          color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
          elide: Text.ElideRight
        }

        Item { Layout.fillWidth: true }

        // Close button (active only)
        Item {
          visible: root.isActive
          implicitWidth: 20
          implicitHeight: 20

          Rectangle {
            anchors.fill: parent
            radius: 4
            color: closeArea.containsMouse
              ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
              : "transparent"
            Behavior on color { ColorAnimation { duration: 110 } }
          }
          StyledText {
            anchors.centerIn: parent
            text: "󰅖"
            font.pixelSize: Config.fontSize - 2
            color: closeArea.containsMouse
              ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
              : (Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3)
          }
          MouseArea {
            id: closeArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.dismiss()
          }
        }
      }

      StyledText {
        Layout.fillWidth: true
        text: root._summary
        visible: root._summary.length > 0
        font.pixelSize: Config.fontSize - 1
        font.weight: Font.Medium
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
        elide: Text.ElideRight
        maximumLineCount: 1
      }

      StyledText {
        Layout.fillWidth: true
        text: root._body
        visible: root._body.length > 0
        font.pixelSize: Config.fontSize - 2
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        wrapMode: Text.WordWrap
        maximumLineCount: 3
        elide: Text.ElideRight
      }
    }
  }
}
