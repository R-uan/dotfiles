import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Io
import "../components"
import "../services"
import ".."

Item {
    id: root
    width: butText.width + 5
    height: butText.height + 10
    
    required property QsWindow rootWindow

    Component.onCompleted: {
        WallpaperService.getImages()
    }

    MouseArea {
        id: mouse
        anchors.fill: root
        onClicked: {
            
            if (selectorPopup.visible) selectorPopup.visible = false
            else {                               
                const pos = root.mapToItem(rootWindow.contentItem, 0, root.height + 10);
                selectorPopup.display(pos.x, pos.y)
                
            }
        }

        onDoubleClicked: {
            WallpaperService.getImages()
        }
    }

    CommonText {
        id: butText
        text: ""
        color: Theme.accent2
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }  

    PopupWindow {
        id: selectorPopup
        implicitWidth: 250
        implicitHeight: 985
        anchor.window: root.rootWindow
        color: "transparent"

        function display(x, y) {
            selectorPopup.anchor.rect.x = x
            selectorPopup.anchor.rect.y = y
            selectorPopup.visible = true
        }

        Rectangle {
            radius: 6
            border.color: Theme.darkLight
            color: Theme.dark
            width: selectorPopup.width
            height: selectorPopup.height
        }

            Item {
                id: topDisplay
                anchors.fill: parent
                ColumnLayout {
                    spacing: 5
                    anchors.centerIn: parent
                    Repeater {
                        model: WallpaperService.imagePaths
                        delegate: Item {
                            id: imgDisplay
                            Layout.preferredHeight: 135
                            Layout.preferredWidth: 240
                            layer.enabled: true
                            layer.smooth: true
                            layer.effect: OpacityMask {
                                 maskSource: Item {
                                    width: image.width
                                    height: image.height
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 4
                                        color: "white" // Fully opaque white for mask
                                    }
                                }
                            } 
                            Image {
                                id: image
                                source: modelData
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectCrop
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 4
                                    border.width: 1
                                    color: "black"
                                    opacity: imageHover.containsMouse ? 0.25 : 0
                                    border.color: Theme.accent
                                }
                                
                                MouseArea {
                                    id: imageHover
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    onClicked: {
                                        WallpaperService.displayWallpaper(modelData)
                                    }
                                }
                            }
                        }
                    }
                
            }
        }
    }
}
