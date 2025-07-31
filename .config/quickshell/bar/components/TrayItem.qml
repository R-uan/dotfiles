pragma ComponentBehavior: Bound

import ".."
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

MouseArea {
    id: root
    implicitWidth: Theme.fontSize * 1.2
    implicitHeight: Theme.fontSize * 1.2
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    required property SystemTrayItem modelData

    onClicked: event => {
        if (event.button === Qt.LeftButton)
            modelData.activate();
        else
            modelData.secondaryActivate();
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
