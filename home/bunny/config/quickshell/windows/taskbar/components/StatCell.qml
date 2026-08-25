import qs.shared
import qs.config

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  property string label: ""
  property int percent: 0
  property color fillColor: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
  property string icon: ""   // if set, shown in the ring instead of the number

  implicitWidth: 34
  implicitHeight: ring.height + labelText.implicitHeight + 4

  Ring {
    id: ring
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    width: 30
    height: 30
    strokeWidth: 3
    value: root.percent / 100
    fillColor: root.fillColor
    trackColor: Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.10)
  }

  StyledText {
    anchors.centerIn: ring
    text: root.icon.length > 0 ? root.icon : String(root.percent)
    font.pixelSize: root.icon.length > 0 ? 12 : 10
    font.weight: Font.Medium
    color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  }

  StyledText {
    id: labelText
    anchors.top: ring.bottom
    anchors.topMargin: 2
    anchors.horizontalCenter: parent.horizontalCenter
    text: root.label
    font.pixelSize: 8
    font.letterSpacing: 1.2
    color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
  }
}
