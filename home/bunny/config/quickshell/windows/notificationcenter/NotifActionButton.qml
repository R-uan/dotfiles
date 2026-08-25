import qs.shared
import qs.config

import QtQuick

Item {
  id: root
  property string label: ""
  signal clicked()

  implicitHeight: 22
  implicitWidth: txt.implicitWidth + 16

  Rectangle {
    anchors.fill: parent
    radius: 6
    color: ma.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04))
    border.color: Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.08)
    border.width: 1
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  StyledText {
    id: txt
    anchors.centerIn: parent
    text: root.label
    font.pixelSize: Config.fontSize - 4
    font.letterSpacing: 1.2
    color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
