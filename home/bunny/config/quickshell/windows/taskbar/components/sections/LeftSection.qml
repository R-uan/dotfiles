import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

// Left Section
Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: layout.implicitHeight

  ColumnLayout {
    id: layout
    anchors.margins: 0
    width: parent.width
    spacing: Config.spacing + 4

    Startup {
      Layout.topMargin: 10
    }

    Resources {
      Layout.topMargin: 6
    }
  }
}
