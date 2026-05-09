import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Layouts

// Right Section
Item {
  id: root
  height: parent.height
  width: layout.implicitWidth

  RowLayout {
    id: layout
    spacing: Theme.spacing
    height: parent.height

    Tray {
      Layout.preferredHeight: parent.height
      Background {
        z: -1
        anchors.fill: parent
      }
    }

    YepClock {
      Background {
        z: -1
        anchors.fill: parent
      }
    }
  }
}
