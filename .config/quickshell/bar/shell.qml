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
            implicitHeight: 40

            Rectangle {
                radius: 6
                color: "#0F0514"
                anchors.fill: parent

                RowLayout {
                    width: parent.width
                    height: parent.height

                    SysResources {
                        Layout.preferredHeight: parent.height - 4
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.margins: 2
                    }

                    // Left Container
                    RowLayout {
                        Layout.preferredHeight: parent.height
                        Layout.alignment: Qt.AlignRight

                        Volume {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: parent.height - 4
                            Layout.margins: 2
                        }

                        DateTime {
                            Layout.preferredHeight: parent.height - 4
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.margins: 2
                        }
                    }
                }
            }

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                left: 5
                right: 5
                top: 5
            }
        }
    }
}
