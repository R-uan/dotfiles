import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import qs
import qs.taskbar
import qs.taskbar.shared
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

    Item {
      Layout.leftMargin: 7
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredWidth: nix.width
      // Layout.preferredHeight: nix.height - (nix.font.pixelSize * 0.5)
      Layout.preferredHeight: parent.height

      MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
          menu.visible = !menu.visible;
          menu.timer.interval = 2000;
          menu.timer.running = true;
        }
      }

      Rectangle {
        color: "transparent"
        anchors.fill: parent
      }

      CommonText {
        id: nix
        text: "󱄅"
        anchors.centerIn: parent
        color: Theme.primary
        font.pixelSize: 27
      }
    }

    Workspaces {
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredHeight: parent.height
    }
  }
}
