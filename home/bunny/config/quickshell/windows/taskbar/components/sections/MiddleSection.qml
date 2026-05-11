import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

// Middle Section
Item {
  id: root
  width: layout.width
  height: parent.height

  RowLayout {
    id: layout
    anchors.margins: 0
    height: parent.height

    Workspaces {
      Background {
        z: -1
        anchors.fill: parent
      }
    }
  }
}
