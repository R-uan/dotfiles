pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Bluetooth
import "../components"
import ".."

PopupWindow {
    id: popup
    visible: true
    implicitWidth: root.width
    implicitHeight:root.height
    color: "transparent"
    anchor.rect.y: 50
    anchor.rect.x: 600
    
    function display(x, y) {
        popup.anchor.rect.x = x;
        popup.anchor.rect.y = y;
        popup.visible = true;
    }

    Item {
        id: root
        height: layout.height
        width: 380

        Rectangle {
            anchors.fill: parent
            color: Theme.dark
            border.color: Theme.borderColor
        }

        ColumnLayout {
            id: layout
            width: root.width
            height: header.height + body.height
            Item {
                id: header
                Layout.margins: 3
                Layout.preferredHeight: txt.height  + 6
                Layout.preferredWidth: parent.width - 6
                
                Rectangle {
                    anchors.fill: parent
                    border.color: Theme.accent
                    color: "transparent"
                }
                
                CommonText {
                    id: txt
                    anchors.margins: 3
                    text: "Bluetooth Devices"
                }    
            }

            Item {
                id: body
                Layout.preferredHeight: content.height > 0 ? content.height : 10
                Layout.preferredWidth: parent.width - 6 
                
                ColumnLayout {
                    id: content
                    width: parent.width    
                }
            }
        }
    }
}
