import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import "../services"
import "../components"
import ".."

Rectangle {
    radius: 4
    Layout.preferredWidth: textItem.width + 16
    color: mouseArea.containsMouse ? Theme.accent : "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
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
