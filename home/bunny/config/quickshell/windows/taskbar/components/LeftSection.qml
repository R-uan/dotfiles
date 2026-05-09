import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

// Left Section
Item {
  id: root
  width: layout.width
  height: parent.height

  RowLayout {
    id: layout
    anchors.margins: 0
    height: parent.height
    spacing: Theme.spacing

    Startup {
      Background {
        z: -1
        anchors.fill: parent
      }
    }

    Resources {
      Layout.preferredHeight: parent.height
      Background {
        z: -1
        anchors.fill: parent
      }
    }

    Playing {
      Layout.preferredHeight: parent.height
    }
  }
}
