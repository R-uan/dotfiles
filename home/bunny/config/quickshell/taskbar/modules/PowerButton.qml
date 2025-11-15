import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import qs.taskbar
import qs.taskbar.shared
import qs.taskbar.services

Item {
    id: root
    width: butText.width + 12
    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

    Rectangle {
        anchors.fill: parent
        border.color: Theme.border
        opacity: Theme.backgroundOpacity
        color: mouseArea.containsMouse ? Theme.primaryHover : Theme.background
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    CommonText {
        id: butText
        text: ""
        font.pixelSize: 13
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
        color: mouseArea.containsMouse ? Theme.foregroundHover : Theme.foreground
    }
}
