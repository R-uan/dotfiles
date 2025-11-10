import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import qs.taskbar
import qs.taskbar.shared
import qs.taskbar.services

Rectangle {
    radius: 2
    border.color: Theme.border
    opacity: Theme.backgroundOpacity
    Layout.preferredWidth: textItem.width + 16
    color: mouseArea.containsMouse ? Theme.primaryHover : Theme.background

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent
    }

    CommonText {
        id: textItem

        anchors.centerIn: parent
        text: NetworkManager.connection
        color: mouseArea.containsMouse ? Theme.foregroundHover : Theme.foreground
    }

}
