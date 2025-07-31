import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../components"

Item {
    id: root
    height: parent.height
    width: layout.width

    // Rectangle {
    //     color: "blue"
    //     anchors.fill: root
    // }

    Row {
        id: layout
        spacing: 5
        anchors.verticalCenter: root.verticalCenter
        Repeater {
            id: workspaces
            model: Hyprland.workspaces
            delegate: WorkspaceItem {
                dHeight: root.height
            }
        }
    }
}
