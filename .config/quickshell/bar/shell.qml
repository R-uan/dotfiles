//@ pragma Env QS_NO_RELOAD_POPUP=0
import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import "./modules/"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
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
                            z: -1
                            radius: 4
                            color: Theme.dark
                            anchors.fill: leftSegment
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
                        spacing: 0
                        anchors.margins: 2
                        height: parent.height - 4
                        width: parent.width / 4.4
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            radius: 4
                            color: Theme.dark
                            anchors.fill: rightSegment
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        NetworkConn {
                            Layout.margins: 2
                            Layout.preferredHeight: parent.height - 4
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }

                        Volume {
                            Layout.margins: 2
                            Layout.preferredHeight: parent.height - 4
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        MiniMenu {
                            id: miniMenu
                            Layout.preferredWidth: miniMenu.width
                            Layout.margins: 4
                            Layout.preferredHeight: parent.height - 8
                        }
                    }
                }
            }
        }
    }
}
