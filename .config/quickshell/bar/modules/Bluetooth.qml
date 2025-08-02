pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Bluetooth
import QtQuick.Layouts

import "../components"
import "../popups"
import ".."

MouseArea {
    id: root
    height: parent.height
    width: display.width + 10
    hoverEnabled: true

    property BluetoothDevice connectedDevice
    required property QsWindow barWindow

    Rectangle {
        radius: 6
        color: root.containsMouse ? Theme.accent : "transparent"
        anchors.fill: root
    }

    CommonText {
        id: display
        text: Bluetooth.defaultAdapter.enabled ? "󰂯 on" : "󰂯 off"
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            if (popup.visible) popup.visible = false
            else {       
                const pos = root.mapToItem(barWindow.contentItem, 0, root.height + 5);
                popup.display(pos.x, pos.y)
            }
        }
    }

    PopupWindow {
        id: popup
        implicitWidth: 370
        color: "transparent"
        anchor.window: barWindow
        implicitHeight: layout.height

        function display(x, y) {
            popup.anchor.rect.x = x;
            popup.anchor.rect.y = y;
            popup.visible = true;
        }

        Rectangle {
            radius: 6
            color: Theme.dark  
            width: parent.width
            height: parent.height
        }

        ColumnLayout {
            id: layout
            width: popup.width
            
            Item {
                id: header
                Layout.preferredHeight: hLayout.height
                Layout.preferredWidth: layout.width
                
                Rectangle {
                    topRightRadius: 6
                    topLeftRadius: 6
                    color: Theme.accentDark
                    width: parent.width
                    height: parent.height
                }
                
                RowLayout {
                    id: hLayout
                    width: parent.width
                    
                    CommonText {
                        Layout.margins: 4
                        text: "paired devices"
                    }

                    Item { Layout.fillWidth: true }
                    
                    MouseArea {
                        Layout.margins: 2
                        width: xdx.width + 6
                        height: xdx.height + 6

                        onClicked: event => {
                            if (Bluetooth.defaultAdapter.discovering) Bluetooth.defaultAdapter.discovering = false
                            else Bluetooth.defaultAdapter.discovering = true
                        }
                        
                        Rectangle {
                            radius: 2
                            anchors.fill: parent
                            color: Theme.accent
                        }
                        
                        CommonText {
                            id: xdx
                            anchors.centerIn: parent
                            text: { Bluetooth.defaultAdapter?.discovering ? "󰘤" : "󱉶" }
                        }
                    }
                }
            }
        
            ColumnLayout {
                spacing: 0
                id: devices

                Repeater {
                    model: Bluetooth.defaultAdapter.devices
                    delegate: BluetoothMenuItem {
                        Layout.margins: 2
                        Layout.preferredWidth: popup.width - 4
                    }
                }
            }
        }
     }
}

