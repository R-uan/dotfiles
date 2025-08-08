import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import "./common"
import "./services"

Rectangle {
    radius: 2
    border.color: Theme.borderColor
    Layout.preferredWidth: textItem.width + 16
    color: mouseArea.containsMouse ? Theme.accent : "transparent"

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
    }

    CommonText {
        id: textItem
        anchors.centerIn: parent
        text: NetworkManager.connection
    }
}
