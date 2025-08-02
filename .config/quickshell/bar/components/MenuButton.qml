import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "../components"
import ".."

Item {
    id: root

    property string icon
    property int size
    property var commands
    
    width: butText.width + 5
    height: butText.height + 10

    MouseArea {
        anchors.fill: root
        onClicked: {
            if (proc.running) return;
            proc.running = true
            
        }
    }

    Process {
        id: proc
        running: false        
        command: root.commands
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
