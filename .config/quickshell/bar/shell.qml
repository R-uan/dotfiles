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
    id: bar
    visible: true
    required property var modelData
    screen: modelData
    color: "transparent"
    implicitHeight: 31

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
            RowLayout {
                id: leftSegment
                anchors.margins: 2
                anchors.left: parent.left
                height: parent.height - 4
                width: parent.width / 4.4
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    radius: 4
                    color: Theme.dark
                    anchors.fill: leftSegment
                    opacity: Theme.backgroundOpacity
                }

                Workspaces {
                    Layout.rightMargin: 2
                    Layout.preferredHeight: parent.height - 4
                }
            }

            // CENTER SEGMENT
            Item {
                height: parent.height
                width: parent.width / 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                DateTime {
                    anchors.margins: 2
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                SysResources {
                    anchors.margins: 2
                    height: parent.height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // RIGHT SEGMENT
            RowLayout {
                id: rightSegment
                spacing: 16
                anchors.margins: 2
                height: parent.height - 4
                width: parent.width / 4.4
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    radius: 4
                    color: Theme.dark
                    opacity: Theme.backgroundOpacity
                    anchors.fill: rightSegment
                }
                
                Item {
                    Layout.fillWidth: true
                }

                Tray {}

                RowLayout {
                    id: rightContainer0
                    spacing: 0
                    Layout.preferredHeight: rightSegment.height

                    
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
    }
}

