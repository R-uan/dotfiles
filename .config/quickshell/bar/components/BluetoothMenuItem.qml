import Quickshell
import Quickshell.Io
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
        font.weight: 400
    }

    Item { Layout.fillWidth: true }

    CommonText {
        Layout.alignment: Qt.AlignHCenter
        color: {
            if (root.modelData.paired) return Theme.accent
            else if (root.modelData.connected) return Theme.complementary
            else if (root.modelData.blocked) return Theme.accent2
        }
            
        text: {
            if (root.modelData.paired) {
                if (root.modelData.trusted) return "Trusted"
                else return "Paired"
            } 
            else if (root.modelData.connected) return "Connected"
            else if (root.modelData.pairing) return "Pairing"
            else if (root.modelData.blocked) return "Blocked"
        }       
    }


    Item { Layout.fillWidth: true}

    RowLayout {
        spacing: 2
        Layout.preferredHeight: parent.height
        
        Item {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: discTxt.width + 10
            
            Rectangle {
                bottomLeftRadius: 6
                topLeftRadius: 6
                color: conBtn.containsMouse ? "#538F46" : Theme.complementary
                anchors.fill: parent
            }

            MouseArea {
                id: conBtn
                anchors.fill: parent
                hoverEnabled: true
                onClicked: event => {
                    if (root.modelData.paired) {
                        if (!root.modelData.connected) root.modelData.connect()
                        else root.modelData.disconnect()                    
                    }
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
                color: forgetbtn.containsMouse ? Theme.accentDark : Theme.accent
                bottomRightRadius: 6
                anchors.fill: parent
            }

            MouseArea {
                id: forgetbtn
                hoverEnabled: true
                anchors.fill: parent
                onClicked: event => {
                    if (root.modelData.paired) root.modelData.forget()
                    else pairDevice.running = true
                }
            }
            
            Process {
                id: pairDevice
                command: ["bluetoothctl", "pair", root.modelData.address]
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
