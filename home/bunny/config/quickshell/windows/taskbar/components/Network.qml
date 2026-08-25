import qs.config
import qs.shared
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent ? parent.width : 28
  implicitHeight: 26

  readonly property bool _connected: NetworkService.netState === "connected"
  readonly property bool _weak: NetworkService.type === "wifi" && _connected && NetworkService.signalStrength < 40

  Rectangle {
    anchors.centerIn: parent
    width: 26
    height: width
    radius: 7
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : "transparent"
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  StyledText {
    id: iconText
    anchors.centerIn: parent
    text: NetworkService.icon
    font.pixelSize: 13
    color: !root._connected
      ? (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
      : (root._weak
          ? (Config.darkMode ? ThemeDark.warning : ThemeLight.warning)
          : (mouseArea.containsMouse
              ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
              : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)))
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (networkmenu.visible) {
        networkmenu.visible = false;
        networkmenu.timer.running = false;
      } else {
        networkmenu.visible = true;
      }
    }
  }
}
