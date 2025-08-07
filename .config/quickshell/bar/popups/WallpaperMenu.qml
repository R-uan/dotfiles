import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.components
import ".."
import qs.services


PopupWindow {
    id: selectorPopup
    implicitWidth: 250
    implicitHeight: 985
    color: "transparent"
    anchor.rect.x: 1868
    anchor.rect.y: 34

    property bool active: false

    function display(x, y) {
        selectorPopup.visible = true
        selectorPopup.anchor.rect.x = x - 50
        selectorPopup.anchor.rect.y = y - 3
        hideTimer.start()
    }

    function hide() {
        selectorPopup.visible = false
    }

    Timer {
        id: hideTimer
        interval: 5000
        repeat: false
        onTriggered: selectorPopup.visible = false
    }

    Rectangle {
        radius: 2
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
                                radius: 2
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
