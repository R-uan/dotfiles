import qs
import qs.shared
import qs.taskbar.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Window

Rectangle {
  radius: 2
  Layout.preferredWidth: textItem.width + 16
  color: mouseArea.containsMouse ? Theme.primaryHover : Theme.background

  MouseArea {
    id: mouseArea
    hoverEnabled: true
    anchors.fill: parent
  }

  CommonText {
    id: textItem
    color: Theme.foreground
    anchors.centerIn: parent
    text: NetworkManager.connection
  }
}
