import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

// Middle Section
Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: layout.implicitHeight

  ColumnLayout {
    id: layout
    width: parent.width
    spacing: Config.spacing

    Workspaces {
      Layout.alignment: Qt.AlignHCenter
    }
  }
}
