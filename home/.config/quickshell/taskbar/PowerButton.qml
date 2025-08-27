import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import "./common"
import "./services"

Item {
    id: root
    width: butText.width + 12
    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.borderColor
    }

    MouseArea {
        id: mouse
        anchors.fill: root
    }

    CommonText {
        id: butText
        text: ""
        font.pixelSize: 13
        color: Theme.foreground
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }
}
