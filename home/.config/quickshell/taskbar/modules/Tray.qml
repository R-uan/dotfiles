pragma ComponentBehavior: Bound

import QtQuick
import qs.taskbar.shared
import qs.taskbar.services

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.taskbar

Item {
    id: root
    clip: true
    visible: { items.count > 0 }
    implicitWidth: layout.width + 16
    implicitHeight: parent.height
    
    required property QsWindow statusBarWindow

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.color: Theme.border
        opacity: Theme.backgroundOpacity
    }

    Row {
        id: layout

        spacing: 3
        anchors.centerIn: root
        layoutDirection: Qt.RightToLeft

        Repeater {
            id: items
            model: SystemTray.items
            delegate: MouseArea {
                id: trayItem
                implicitWidth: Theme.fontSize * 1.2
                implicitHeight: Theme.fontSize * 1.2
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                required property SystemTrayItem modelData

                onClicked: event => {
                    if (event.button === Qt.LeftButton)
                        modelData.activate();
                    else {
                        if (modelData.hasMenu) {
                            const pos = mapToItem(root.statusBarWindow.contentItem, 0, height + 5);
                            const offsetX = pos.x + (width / 2) - (popup.implicitWidth / 2);
                           modelData.display(popup, pos.x, pos.y);
                        }
                    }
                }

                PopupWindow {
                    id: popup
                    anchor.window: root.statusBarWindow
                }

                IconImage {
                    asynchronous: true
                    anchors.fill: parent

                    source: {
                        let icon = trayItem.modelData.icon;
                        if (icon.includes("?path=")) {
                            const [name, path] = icon.split("?path=");
                            icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
                        }
                        return icon;
                    }
                }
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 1
            easing.bezierCurve: 2
            easing.type: Easing.BezierSpline
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 1
            easing.bezierCurve: 2
            easing.type: Easing.BezierSpline
        }
    }
}
