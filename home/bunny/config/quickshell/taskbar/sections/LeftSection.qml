import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import qs
import qs.taskbar
import qs.taskbar.modules

// Left Section
Rectangle {
  id: root
  border.width: 0
  radius: Theme.radius
  height: parent.height
  color: Theme.background
  opacity: Theme.backgroundOpacity

  RowLayout {
    id: layout
    anchors.margins: 0
    anchors.fill: parent

    TheButton {}

    Workspaces {
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredHeight: parent.height
    }
  }
}
