//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=0
import QtQuick
import Quickshell
import "./modules/"
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.SystemTray

PanelWindow {
    id: root
    visible: true
    implicitHeight: 35
    color: "transparent"
    objectName: "Status Bar Window"

    required property var modelData

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        left: 3
        right: 3
        top: 5
    }

    Rectangle {
        radius: 6
        color: "transparent"
        anchors.fill: parent

        Item {
            width: parent.width
            anchors.fill: parent
            height: parent.height

            // LEFT SEGMENT
            Item {
                id: leftSegmentWrapper
                height: parent.height - 4
                width: parent.width / 4.4
                
                Rectangle {
                    radius: 4
                    color: Theme.dark
                    anchors.fill: parent
                    opacity: Theme.backgroundOpacity
                }
                
                RowLayout {
                    id: leftSegment
                    anchors.margins: 2
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Workspaces {
                        Layout.leftMargin: 2
                        Layout.preferredHeight: parent.height - 4
                    }
                }
            }

            // CENTER SEGMENT
            Item {
                height: parent.height
                width: parent.width / 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                SysResources {
                    anchors.margins: 2
                    height: parent.height - 4 
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: -310 
                    anchors.verticalCenter: parent.verticalCenter
                }

                DateTime {
                    anchors.margins: 2
                    height: parent.height - 4
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Item {
                id: rightSegmentWrapper    
                width: parent.width / 4.4
                height: parent.height - 4
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                
                Rectangle {
                    radius: 4
                    color: Theme.dark
                    anchors.fill: parent
                    opacity: Theme.backgroundOpacity
                }

                
                RowLayout {
                    id: rightSegment
                    spacing: 12
                    anchors.margins: 2
                    anchors.fill: parent
                
                    Item {
                        Layout.fillWidth: true
                    }

                    Tray {
                        barWindow: root
                    }

                    RowLayout {
                        id: rightContainer0
                        spacing: 0
                        Layout.preferredHeight: rightSegment.height

                        Bluetooth {
                            barWindow: root
                            Layout.margins: 1
                            Layout.preferredHeight: rightContainer0.height - 2
                        }
                    
                        NetworkConn {
                            Layout.margins: 1
                            Layout.preferredHeight: parent.height - 2
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }

                        Volume {
                            Layout.margins: 1
                            Layout.preferredHeight: parent.height - 2
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                    }


                    MiniMenu {
                        id: miniMenu
                        Layout.preferredWidth: miniMenu.width
                        Layout.rightMargin: 4
                        Layout.preferredHeight: parent.height - 8
                    }
                }
            }

            // RIGHT SEGMENT
        }
    }
}

