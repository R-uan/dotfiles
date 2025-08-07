//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=0
import QtQuick
import Quickshell
import QtQuick.Layouts

import "modules"
import "components"
import "popups"

PanelWindow {
    id: root
    visible: true
    implicitHeight: 30
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
        top: 3
    }

    Rectangle {
        radius: 2
        color: Theme.dark
        anchors.fill: parent

        Item {
            width: parent.width
            anchors.fill: parent
            height: parent.height

            // LEFT SEGMENT
            Item {
                id: leftSegmentWrapper
                height: parent.height
                // width: leftSegment.width

                RowLayout {
                    id: leftSegment
                    anchors.leftMargin: 3
                    height: parent.height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Workspaces {
                        Layout.leftMargin: 2
                        Layout.preferredHeight: leftSegmentWrapper.height - 6
                    }
                }
            }

            // CENTER SEGMENT
            RowLayout {
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                DateTime {
                    Layout.preferredHeight: parent.height - 6
                }
            }

            RowLayout {
                spacing: 3
                height: parent.height
                anchors.right: parent.right
                
                Rectangle {
                    color: "blue"
                    Layout.fillWidth: parent.width
                    Layout.fillHeight: parent.height
                }

                Tray {
                    barWindow: root
                    Layout.preferredHeight: parent.height - 6
                }

                SysResources {
                    Layout.minimumHeight: parent.height - 6
                }

                RowLayout {
                    spacing: 3
                    Layout.preferredHeight: parent.height

                    NetworkConn {
                        Layout.minimumHeight: parent.height - 6
                    }

                    Volume {
                        Layout.minimumHeight: parent.height - 6
                    }
                }

                MiniMenu {
                    rootWindow: root
                    Layout.rightMargin: 3
                    Layout.preferredHeight: parent.height - 6
                }
            }
        }
    }
}
