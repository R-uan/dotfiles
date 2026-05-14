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

    // Debug {}
    Tray {}

    // Debug {}
    Resources {}

    // Debug {}
    SystemServices {}

    // Debug {}
    YepClock {}

    Item {
      Layout.topMargin: -5
      Layout.bottomMargin: 10
      implicitWidth: parent.width
      implicitHeight: pb.height

      StyledText {
        id: pb
        font.pixelSize: 20
        anchors.centerIn: parent
        text: "󰐥"
      }
    }
  }
}
