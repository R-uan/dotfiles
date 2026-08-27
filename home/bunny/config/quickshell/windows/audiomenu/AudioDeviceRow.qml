import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  property var node
  property bool active: false
  signal activated()

  implicitHeight: 30

  Rectangle {
    anchors.fill: parent
    radius: 6
    color: root.active
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.09) : Qt.rgba(0,0,0,0.07))
      : (ma.containsMouse
          ? (Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.05))
          : "transparent")
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 8
    anchors.rightMargin: 8
    spacing: 8

    StyledText {
      text: AudioService.nodeIcon(root.node)
      font.pixelSize: Config.fontSize - 1
      color: root.active
        ? (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
        : (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
    }

    StyledText {
      Layout.fillWidth: true
      text: AudioService.nodeLabel(root.node)
      font.pixelSize: Config.fontSize - 3
      font.weight: root.active ? Font.Medium : Font.Normal
      color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
      elide: Text.ElideRight
    }

    StyledText {
      visible: root.active
      text: "󰄬"
      font.pixelSize: Config.fontSize - 2
      color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
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
