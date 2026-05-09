import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  id: root
  height: parent.height
  implicitWidth: layout.implicitWidth + 20

  RowLayout {
    id: layout
    spacing: Theme.spacing * 2
    anchors.centerIn: parent

    Repeater {
      model: ResourcesService.stats
      delegate: RowLayout {
        spacing: Theme.spacing * 2

        SeparatorDot {
          Layout.alignment: Qt.AlignVCenter
          visible: index > 0
        }

        StyledText {
          text: modelData
          color: Theme.foreground
          Layout.alignment: Qt.AlignVCenter
        }
      }
    }
  }
}