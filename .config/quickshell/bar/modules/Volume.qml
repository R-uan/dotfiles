import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import "../services"
import "../components"
import ".."

Rectangle {
    radius: 2
    Layout.alignment: Qt.AlignCenter
    Layout.preferredWidth: textItem.width + 16
    border.color: Theme.borderColor
    border.width: 1
    color: mouseArea.containsMouse ? Theme.accent : "transparent"

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
    }
}
