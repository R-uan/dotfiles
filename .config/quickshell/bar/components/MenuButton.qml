import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "../components"
import ".."

Item {
    id: root

    property string icon
    property int size
    property var onClick
    
    width: butText.width + 5
    height: butText.height + 10

    MouseArea {
        id: mouse
        anchors.fill: root
    }

    CommonText {
        id: butText
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
        text: root.icon
        font.pixelSize: root.size
        color: Theme.accent2
    }
}
