import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.taskbar.shared
import qs.taskbar.services

RowLayout {
  spacing: 15

  Repeater {
    model: SysResourcesManager.stats

    delegate: Rectangle {
      topLeftRadius: 2
      topRightRadius: 2
      bottomLeftRadius: 2
      color: "transparent"
      bottomRightRadius: 2
      height: parent.height
      Layout.alignment: Qt.AlignCenter
      Layout.preferredWidth: textItem.width

      HoverHandler {
        id: hoverHandler
      }

      CommonText {
        id: textItem
        text: modelData
        anchors.centerIn: parent
        color: hoverHandler.hovered ? Theme.primaryHover : Theme.foreground
      }
    }
  }
}
