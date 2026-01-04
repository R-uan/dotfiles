import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import qs
import qs.taskbar
import qs.taskbar.shared

Item {
  Layout.leftMargin: 7
  Layout.preferredWidth: nix.width
  Layout.alignment: Qt.AlignVCenter
  Layout.preferredHeight: parent.height

  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onClicked: {
      if (quickMenu.visible) {
        quickMenu.visible = false;
        quickMenu.timer.running = false;
      } else {
        quickMenu.visible = true;
        // quickMenu.timer.interval = 2000;
        // quickMenu.timer.running = true;
      }
    }
  }

  CommonText {
    id: nix
    text: "󱄅"
    font.pixelSize: 27
    color: Theme.primary
    anchors.centerIn: parent
  }
}
