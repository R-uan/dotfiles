import qs.config
import qs.shared
import qs.windows.startmenu
import qs.windows.taskbar.components
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens
        Scope {
            required property var modelData
            property int secondaryBarsSize: 7

            // LEFT
            PanelWindow {
                visible: true
                id: mainWindow
                screen: modelData
                color: "transparent"
                objectName: "Status Bar Window"
                WlrLayershell.layer: WlrLayer.Top
                implicitWidth: Config.thickness + 10

                anchors {
                    top: true
                    left: true
                    bottom: true
                    right: false
                }

                Background {
                    z: -1
                    radius: 0
                    anchors.fill: parent
                    border.color: "transparent"
                }

                LeftSection {
                    id: left
                    width: parent.width
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                RightSection {
                    id: right
                    width: parent.width
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            
            // TOP
            PanelWindow {
                visible: true
                screen: modelData
                color: "transparent"
                objectName: "Top Bar"
                implicitHeight: secondaryBarsSize 
                WlrLayershell.layer: WlrLayer.Top

                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: false
                }

                Background {
                    z: -1
                    radius: 0
                    anchors.fill: parent
                    border.color: "transparent"
                }        
            }

            // BOTTOM
            PanelWindow {
                visible: true
                screen: modelData
                color: "transparent"
                objectName: "Top Bar"
                implicitHeight: secondaryBarsSize 
                WlrLayershell.layer: WlrLayer.Top

                anchors {
                    top: false
                    left: true
                    right: true
                    bottom: true
                }

                Background {
                    z: -1
                    radius: 0
                    anchors.fill: parent
                    border.color: "transparent"
                }        
            }

            // RIGHT
            PanelWindow {
                visible: true
                screen: modelData
                color: "transparent"
                objectName: "Top Bar"
                implicitWidth: secondaryBarsSize
                WlrLayershell.layer: WlrLayer.Top

                anchors {
                    top: true
                    left: false
                    right: true
                    bottom: true
                }

                Background {
                    z: -1
                    radius: 0
                    anchors.fill: parent
                    border.color: "transparent"
                }        
            }
            
            // TOP LEFT CORNER
            PanelWindow {
                screen: modelData
                color: "transparent"
                implicitWidth: Config.rounding
                implicitHeight: Config.rounding
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:barCorners"

                mask: Region {}

                anchors {
                    top: true
                    left: true
                }

                RoundCorner {
                    anchors.fill: parent
                    implicitSize: Config.rounding
                    corner: RoundCorner.CornerEnum.TopLeft
                }
            }

            // BOTTOM LEFT CORNER
            PanelWindow {
                screen: modelData
                color: "transparent"
                implicitWidth: Config.rounding
                implicitHeight: Config.rounding
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:barCorners"

                mask: Region {}

                anchors {
                    bottom: true
                    left: true
                }

                RoundCorner {
                    anchors.fill: parent
                    implicitSize: Config.rounding
                    corner: RoundCorner.CornerEnum.BottomLeft
                }
            }

            // TOP RIGHT CORNER
            PanelWindow {
                screen: modelData
                color: "transparent"
                implicitWidth: Config.rounding
                implicitHeight: Config.rounding
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:barCorners"

                mask: Region {}

                anchors {
                    top: true
                    right: true
                }

                // Offset to the right edge of the bar
                margins {
                    left: Config.thickness + 10
                }

                RoundCorner {
                    anchors.fill: parent
                    implicitSize: Config.rounding
                    corner: RoundCorner.CornerEnum.TopRight
                }
            }

            // BOTTOM RIGHT CORNER
            PanelWindow {
                screen: modelData
                color: "transparent"
                implicitWidth: Config.rounding
                implicitHeight: Config.rounding
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell:barCorners"

                mask: Region {}

                anchors {
                    bottom: true
                    right: true
                }

                margins {
                    left: Config.thickness + 10
                }

                RoundCorner {
                    anchors.fill: parent
                    implicitSize: Config.rounding
                    corner: RoundCorner.CornerEnum.BottomRight
                }
            }
        }
    }
}