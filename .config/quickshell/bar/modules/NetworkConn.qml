import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import "../services"
import "../components"
import ".."

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

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    CommonText {
        id: textItem
        anchors.centerIn: parent
        text: NetworkConnManager.connection
    }
}
