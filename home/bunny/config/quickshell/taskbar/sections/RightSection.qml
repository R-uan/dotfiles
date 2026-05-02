import qs.shared
import qs.taskbar.modules

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
      SolidBackground {
        z: -1
        anchors.fill: parent
      }
    }

    YepClock {
      SolidBackground {
        z: -1
        anchors.fill: parent
      }
    }
  }
}
