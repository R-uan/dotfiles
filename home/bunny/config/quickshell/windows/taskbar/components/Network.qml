import qs.config
import qs.shared
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Window

Item {
  Layout.preferredWidth: textItem.width + 16

  MouseArea {
    id: mouseArea
    hoverEnabled: true
    anchors.fill: parent
  }

  StyledText {
    id: textItem
    color: Theme.foreground
    anchors.centerIn: parent
    text: NetworkService.connection
  }
}
