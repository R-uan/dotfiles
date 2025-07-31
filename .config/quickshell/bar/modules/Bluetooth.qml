import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Bluetooth
import "../components"

MouseArea {
    id: root
    width: display.width + 10
    
    height: parent.height
    Rectangle {
        color: "red"
        anchors.fill: root
    }

    CommonText {
        id: display
        text: "󰂯 none"
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }

     PopupWindow {
        anchor.window: root.parent
        anchor.rect.x: 20
        anchor.rect.y: 29
        width: 500
        height: 500
        visible: true
     }
}

