import qs.shared
import qs.taskbar.services

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  id: root
  width: 200
  height: parent.height

  RowLayout {
    id: layout
    spacing: 12
    anchors.centerIn: parent
    Repeater {
      model: SysResourcesManager.stats
      delegate: CommonText {
        id: text
        text: modelData
        color: Theme.foreground
        Layout.alignment: Qt.AlignVCenter
      }
    }
  }
}
