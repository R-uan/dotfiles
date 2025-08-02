import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    height: txt.height
    width: parent.width

    required property BluetoothDevice modelData
 
    CommonText {
        Layout.margins: 2
        id: txt
        text: root.modelData.name
        color: root.modelData.connected ? Theme.complementary : root.modelData.paired ? Theme.accent : Theme.foreground
        font.weight: 800
    }

    Item { Layout.fillWidth: true}


    RowLayout {
        Layout.preferredHeight: parent.height
        
        Item {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: discTxt.width + 10
            Rectangle {
                bottomLeftRadius: 6
                topLeftRadius: 6
                color: root.modelData.connected ? Theme.accent2 : Theme.complementary
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: event => {
                    if (!root.modelData.connected) root.modelData.connect()
                    else root.modelData.disconnect()                    
                }
            }

            CommonText {
                id: discTxt
                text: root.modelData.connected ? "" : "󱘖"
                color: Theme.dark
                font.pixelSize:16
                anchors.centerIn: parent
            }
        }

        
        Item {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: unTxt.width + 10
            Rectangle {
                topRightRadius: 6
                color: Theme.accent
                bottomRightRadius: 6
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: event => {
                    if (root.modelData.paired) root.modelData.forget()
                }
            }

            CommonText {
                id: unTxt
                text: ""
                font.pixelSize: 16
                color: Theme.dark
                anchors.centerIn: parent
            }
        }
    }
}
