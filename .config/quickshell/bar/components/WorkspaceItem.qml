pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland
import "../components"
import ".."

Item {
    id: root
    width: modelData.active || hover.containsMouse ? 50 : ws.height
    height: ws.height + 1

    required property int dHeight
    required property HyprlandWorkspace modelData

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }



    Loader {
        anchors.fill: root
        active: root.modelData.active === true || hover.containsMouse === true
        sourceComponent: Rectangle {
            radius: 16
            anchors.fill: parent
            color: hover.containsMouse ? Theme.accent : Theme.complementary
        }
    }
    
    MouseArea {
        id: hover
        hoverEnabled: true
        anchors.fill: root
    }

    CommonText {
        id: ws
        color: modelData.active || hover.containsMouse ? Theme.dark : Theme.foreground
        text: modelData.active ? "󱩡" : modelData.id
        font.weight: 400
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
    }
}

