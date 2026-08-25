import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  property var net
  property bool expanded: false
  signal activated()
  signal submitPassword(string password)
  signal cancelExpand()

  implicitHeight: expanded ? (32 + passwordRow.implicitHeight + 8) : 32

  readonly property bool _inUse:  net && net.inUse
  readonly property int  _sig:    net ? net.signal : 0
  readonly property bool _secure: net && net.secure
  readonly property bool _saved:  net && net.saved

  function _sigIcon(s) {
    if (s >= 80) return "󰤨";
    if (s >= 60) return "󰤥";
    if (s >= 40) return "󰤢";
    if (s >= 20) return "󰤟";
    return "󰤯";
  }

  onExpandedChanged: {
    if (expanded) passwordField.forceActiveFocus();
    else          passwordField.text = "";
  }

  Rectangle {
    id: mainRow
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 32
    radius: 6
    color: root._inUse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.09) : Qt.rgba(0,0,0,0.07))
      : (ma.containsMouse
          ? (Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.05))
          : "transparent")
    Behavior on color { ColorAnimation { duration: 110 } }

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 8
      anchors.rightMargin: 8
      spacing: 8

      StyledText {
        text: root._sigIcon(root._sig)
        font.pixelSize: Config.fontSize
        color: root._inUse
          ? (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
          : (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
      }

      StyledText {
        Layout.fillWidth: true
        text: root.net ? root.net.ssid : ""
        font.pixelSize: Config.fontSize - 2
        font.weight: root._inUse ? Font.Medium : Font.Normal
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
        elide: Text.ElideRight
      }

      StyledText {
        visible: root._saved
        text: "󰄲"
        font.pixelSize: Config.fontSize - 3
        color: Config.darkMode ? ThemeDark.success : ThemeLight.success
      }

      StyledText {
        visible: root._secure
        text: "󰌾"
        font.pixelSize: Config.fontSize - 3
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }

      StyledText {
        text: root._sig + "%"
        font.pixelSize: Config.fontSize - 4
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        Layout.preferredWidth: 28
        horizontalAlignment: Text.AlignRight
      }
    }

    MouseArea {
      id: ma
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.activated()
    }
  }

  // Password entry, only when expanded
  RowLayout {
    id: passwordRow
    visible: root.expanded
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: mainRow.bottom
    anchors.topMargin: 6
    anchors.leftMargin: 8
    anchors.rightMargin: 8
    spacing: 6

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 28
      radius: 6
      color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
      border.color: passwordField.activeFocus
        ? (Config.darkMode ? Qt.rgba(1,1,1,0.20) : Qt.rgba(0,0,0,0.20))
        : (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.10))
      border.width: 1

      TextInput {
        id: passwordField
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        verticalAlignment: TextInput.AlignVCenter
        font.pixelSize: Config.fontSize - 2
        font.family: Config.fontFamily
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
        echoMode: TextInput.Password
        selectByMouse: true
        clip: true
        onAccepted: {
          root.submitPassword(passwordField.text);
        }
        Keys.onEscapePressed: root.cancelExpand()

        StyledText {
          visible: passwordField.text.length === 0 && !passwordField.activeFocus
          anchors.verticalCenter: parent.verticalCenter
          text: "password"
          font.pixelSize: Config.fontSize - 2
          color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        }
      }
    }

    // Connect button
    Rectangle {
      Layout.preferredWidth: 28
      Layout.preferredHeight: 28
      radius: 6
      color: connectBtn.containsMouse
        ? (Config.darkMode ? Qt.rgba(1,1,1,0.14) : Qt.rgba(0,0,0,0.12))
        : (Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06))
      border.color: Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.10)
      border.width: 1
      Behavior on color { ColorAnimation { duration: 110 } }

      StyledText {
        anchors.centerIn: parent
        text: "󰁕"
        font.pixelSize: Config.fontSize
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
      }

      MouseArea {
        id: connectBtn
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.submitPassword(passwordField.text)
      }
    }
  }
}
