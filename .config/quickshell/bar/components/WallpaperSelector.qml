import QtQuick
import Quickshell
import qs.components
import qs.services
import qs.popups
import ".."

Item {
    id: root
    width: butText.width + 5
    height: butText.height + 10
    
    required property QsWindow rootWindow
    property var initialPopupRect
    
    Component.onCompleted: {
        WallpaperService.getImages()
        const pos = root.mapToItem(rootWindow.contentItem, 0, root.height + 10);
        initialPopupRect = [pos.x, pos.y]
    }

    MouseArea {
        id: mouse
        anchors.fill: root
        
        onClicked: {
            if (selectorPopup.visible) selectorPopup.hide()
            else {
                const pos = root.mapToItem(rootWindow.contentItem, 0, root.height + 10);
                selectorPopup.display(pos.x, pos.y)
                autoClose.running = true
            }
        }

        onDoubleClicked: { WallpaperService.getImages() }
    }

    CommonText {
        id: butText
        text: ""
        color: Theme.foreground
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }

    WallpaperMenu {
        id: selectorPopup            
        anchor.window: root.rootWindow
    }
}
