pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland
import "../components"
import ".."

Item {
    id: root
    width: modelData.active || modelData.urgent || hover.containsMouse ? 50 : ws.height
    // height: ws.height 
    height: dHeight - 6

    required property int dHeight
    required property HyprlandWorkspace modelData

    Behavior on width {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    Loader {
        anchors.fill: root
        active: root.modelData.active === true || hover.containsMouse === true || root.modelData.urgent === true
        sourceComponent: Rectangle {
            radius: 2
            anchors.fill: parent
            color: hover.containsMouse ? Theme.complementary : root.modelData.urgent ? Theme.accent2 : Theme.accent
        }
    }
    
    MouseArea {
        id: hover
        hoverEnabled: true
        anchors.fill: root

        onClicked: (event) => {
            if (event.button === Qt.LeftButton) {
                modelData.activate()
            }
        }
    }

    CommonText {
        id: ws
        color: root.modelData.active || hover.containsMouse || root.modelData.urgent ? Theme.dark : Theme.foreground
        text: root.modelData.active ? "󱩡" : root.modelData.id
        font.weight: 400
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
    }
}

