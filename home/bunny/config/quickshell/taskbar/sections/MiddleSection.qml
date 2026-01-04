import qs.shared
import qs.taskbar.modules

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
      SolidBackground {
        z: -1
        anchors.fill: parent
      }
    }
  }
}
