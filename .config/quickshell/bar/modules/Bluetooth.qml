pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Bluetooth
import QtQuick.Layouts

import "../components"
import "../popups"
import ".."

MouseArea {
    id: root
    height: parent.height
    width: display.width + 16
    hoverEnabled: true

    property BluetoothDevice connectedDevice
    required property QsWindow barWindow

    Rectangle {
        radius: 2
        anchors.fill: root
        border.color: Theme.borderColor
        color: root.containsMouse ? Theme.accent : "transparent"
    }

    CommonText {
        id: display
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
        text: Bluetooth.defaultAdapter.enabled ? "󰂯 on" : "󰂯 off"
    }

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            if (popup.visible)
                popup.visible = false;
            else {
                const pos = root.mapToItem(barWindow.contentItem, 0, root.height + 5);
                popup.display(pos.x, pos.y);
            }
        }
    }

    BluetoothMenu {
        id: popup
        anchor.window: barWindow
    }
}
