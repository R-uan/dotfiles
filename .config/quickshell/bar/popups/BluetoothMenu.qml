import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import "../components"

Item {
    width: device.width
    height: device.height + 10
    required property BluetoothDevice modelData
    
    Rectangle {
        color: "red"
        anchors.fill: parent
    }

    CommonText {
        id: device
        text: modelData.name
    }
}
