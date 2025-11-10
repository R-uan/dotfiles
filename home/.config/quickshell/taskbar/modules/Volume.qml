import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import qs.taskbar
import qs.taskbar.shared
import qs.taskbar.services

Rectangle {
    radius: 2
    border.width: 1
    border.color: Theme.border
    // implicitHeight: parent.height
    Layout.alignment: Qt.AlignCenter
    opacity: Theme.backgroundOpacity
    Layout.preferredWidth: textItem.width + 16
    color: mouseArea.containsMouse ? Theme.primaryHover : Theme.background

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onWheel: event => {
            if (event.angleDelta.y > 0)
                VolumeManager.setVolume("+5");
            else
                VolumeManager.setVolume("-5");
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    CommonText {
        id: textItem
        anchors.centerIn: parent
        text: VolumeManager.volumeDisplay
        color: mouseArea.containsMouse ? Theme.foregroundHover : Theme.foreground
    }
}
