import qs.shared
import qs.config
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  height: layout.implicitHeight

  readonly property string accentColor: Config.darkMode ? ThemeDark.colour6 : ThemeLight.primary3
  readonly property string textColor:   Config.darkMode ? ThemeDark.foreground0 : ThemeLight.background0
  
  Background {
    anchors.fill: layout
    color: root.accentColor
    visible: Config.darkMode === false
  }

  ColumnLayout {
    id: layout
    spacing: Config.spacing
    anchors.centerIn: parent
    implicitWidth: parent.width - 8


    Repeater {
      model: ResourcesService.stats
      delegate: Item {
        implicitWidth: parent.width
        implicitHeight: ll.implicitHeight + 10
        Layout.alignment: Qt.AlignHCenter

        ColumnLayout {
          id: ll
          spacing: 0
          anchors.centerIn: parent

          StyledText {
            color: root.textColor
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Config.fontSize - 2
            text: modelData.label.toUpperCase()
          }

          StyledText {
            color: root.textColor
            text: modelData.value
            font.pixelSize: Config.fontSize - 1
            Layout.alignment: Qt.AlignHCenter
          }
        }
      }
    }
  }
}
