import qs.shared
import qs.config

import QtQuick
import QtQuick.Layouts

ColumnLayout {
  id: root
  property string label: ""
  property int percent: 0
  property string rightText: ""
  property string hint: ""
  property color hintColor: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
  property color fillColor: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1

  spacing: 4

  RowLayout {
    Layout.fillWidth: true
    spacing: 6

    StyledText {
      text: root.label
      font.pixelSize: Config.fontSize - 3
      font.letterSpacing: 1.4
      color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
      Layout.preferredWidth: 46
    }
    StyledText {
      Layout.fillWidth: true
      text: root.hint
      font.pixelSize: Config.fontSize - 4
      color: root.hintColor
      elide: Text.ElideRight
    }
    StyledText {
      text: root.rightText
      font.pixelSize: Config.fontSize - 3
      color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
      Layout.preferredWidth: 40
      horizontalAlignment: Text.AlignRight
    }
  }

  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 4
    radius: 2
    color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.08)

    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: Math.max(2, parent.width * Math.min(1, root.percent / 100))
      radius: 2
      color: root.fillColor
      Behavior on width { NumberAnimation { duration: 300 } }
      Behavior on color { ColorAnimation  { duration: 200 } }
    }
  }
}
