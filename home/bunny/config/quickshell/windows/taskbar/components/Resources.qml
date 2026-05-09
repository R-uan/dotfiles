import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  id: root
  width: 200
  height: parent.height

  RowLayout {
    id: layout
    spacing: 13
    anchors.centerIn: parent

    Repeater {
      model: ResourcesService.stats
      delegate: StyledText {
        id: text
        text: modelData
        color: Theme.foreground
        Layout.alignment: Qt.AlignVCenter
      }
    }
  }
}
