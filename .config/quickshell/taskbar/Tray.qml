pragma ComponentBehavior: Bound

import QtQuick
import "./common"
import "./services"
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: root

    clip: true
    visible: width > 0 && height > 0
    implicitWidth: layout.width + 16
    implicitHeight: layout.implicitHeight

    required property QsWindow statusBarWindow

    Rectangle {
        color: "transparent"
        anchors.fill: parent
        border.color: Theme.borderColor
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
                            const pos = mapToItem(statusBarWindow.contentItem, 0, height + 5);
                            const offsetX = pos.x + (width / 2) - (popup.implicitWidth / 2);
                            modelData.display(popup, pos.x, pos.y);
                        }
                    }
                }

                PopupWindow {
                    id: popup
                    anchor.window: statusBarWindow
                }

                IconImage {
                    asynchronous: true
                    anchors.fill: parent

                    source: {
                        let icon = modelData.icon;
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
