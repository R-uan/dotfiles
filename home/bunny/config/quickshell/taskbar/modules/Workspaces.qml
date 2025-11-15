import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.taskbar
import qs.taskbar.shared
import qs.taskbar.services

Item {
    id: root
    height: parent.height
    width: layout.implicitWidth + 6

    Row {
        id: layout
        spacing: 6
        anchors.centerIn: parent

        Repeater {
            id: workspaces
            model: Hyprland.workspaces

            delegate: Rectangle {
                id: wsBox
                radius: 2
                height: root.height
                width: (modelData.active || modelData.urgent || hover.containsMouse) ? 50 : ws.implicitWidth + 10
                color: modelData.urgent ? Theme.rose :
                       hover.containsMouse ? Theme.secondaryHover :
                       modelData.active ? Theme.primaryAccent :
                       "transparent"
                border.color: "transparent"

                Behavior on width {
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }

                MouseArea {
                    id: hover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: if (mouse.button === Qt.LeftButton) modelData.activate()
                }

                CommonText {
                    id: ws
                    anchors.centerIn: parent
                    font.weight: 400
                    text: modelData.active ? "󱩡" : modelData.id
                    color: (hover.containsMouse || modelData.urgent)
                           ? Theme.foregroundHover : Theme.foreground
                }
            }
        }
    }
}
