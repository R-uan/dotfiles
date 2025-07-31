pragma ComponentBehavior: Bound

import ".."
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick.Controls

MouseArea {
    id: root
    implicitWidth: Theme.fontSize * 1.2
    implicitHeight: Theme.fontSize * 1.2
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    required property SystemTrayItem modelData
    required property QsWindow window

    onClicked: event => {
        if (event.button === Qt.LeftButton) modelData.activate();
        else {
            const pos = root.mapToItem(window.contentItem, 0, root.height + 5);
            const offsetX = pos.x + (root.width / 2) - (popup.implicitWidth / 2);
            modelData.display(popup, offsetX, pos.y);
        }
    }

    PopupWindow {
        id: popup
        anchor.window: root.window
        color: "red"
    }

    IconImage {
        id: icon
        asynchronous: true
        anchors.fill: parent

        source: {
            let icon = root.modelData.icon;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
        }
    }
}
