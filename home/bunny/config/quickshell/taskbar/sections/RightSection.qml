import QtQuick
import Quickshell
import QtQuick.Layouts
import qs
import qs.taskbar.shared
import qs.taskbar.modules

// Right Section
Rectangle {
  id: root
  color: "transparent"
  radius: Theme.radius
  height: parent.height
  implicitWidth: layout.implicitWidth

  RowLayout {
    id: layout
    spacing: 3
    anchors.fill: parent

    Tray {
      Layout.preferredHeight: parent.height
    }
    // Separator {}
    SysResources {
      Layout.minimumHeight: parent.height
    }
  }
}
