import "./common"
import "./services"

import QtQuick
import Quickshell
import Quickshell.Hyprland

Item {
    id: root
    width: layout.width
    height: parent.height

    Row {
        id: layout
        spacing: 5
        anchors.verticalCenter: root.verticalCenter

        Repeater {
            id: workspaces
            model: Hyprland.workspaces
            delegate: Item {
                id: iRoot
                height: root.height - 6
                width: modelData.active || modelData.urgent || hover.containsMouse ? 50 : ws.height

                Behavior on width {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }

                Loader {
                    anchors.fill: iRoot
                    active: modelData.active === true || hover.containsMouse === true || modelData.urgent === true
                    sourceComponent: Rectangle {
                        radius: 2
                        anchors.fill: parent
                        color: hover.containsMouse ? Theme.complementary : modelData.urgent ? Theme.accent2 : Theme.accent
                    }
                }

                MouseArea {
                    id: hover
                    hoverEnabled: true
                    anchors.fill: iRoot

                    onClicked: event => {
                        if (event.button === Qt.LeftButton)
                            modelData.activate();
                    }
                }

                CommonText {
                    id: ws
                    font.weight: 400
                    text: modelData.active ? "󱩡" : modelData.id
                    anchors.verticalCenter: iRoot.verticalCenter
                    anchors.horizontalCenter: iRoot.horizontalCenter
                    color: modelData.active || hover.containsMouse || modelData.urgent ? Theme.dark : Theme.foreground
                }
            }
        }
    }
}
