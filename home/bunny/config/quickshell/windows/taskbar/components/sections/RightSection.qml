import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Layouts

// Right Section
Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: layout.implicitHeight

  ColumnLayout {
    id: layout
    anchors.margins: 0
    implicitWidth: parent.width
    spacing: Config.spacing * 1.50

    Tray {}

    SystemServices {}

    YepClock {}

    PowerButton {
      Layout.topMargin: -5
      Layout.bottomMargin: 10
    }
  }
}
