import qs.config
import qs.shared
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Window

Item {
  implicitWidth: textItem.width
  implicitHeight: textItem.height + 10

  MouseArea {
    id: mouseArea
    hoverEnabled: true
    anchors.fill: parent
  }

  StyledText {
    id: textItem
    anchors.centerIn: parent
    text: NetworkService.connection
  }
}
