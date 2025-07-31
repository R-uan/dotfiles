import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import "../services"
import "../components"
import ".."

Rectangle {
    radius: 4
    color: mouseArea.containsMouse ? Theme.accent : "transparent"

    Layout.alignment: Qt.AlignCenter
    Layout.preferredHeight: parent.height
    Layout.preferredWidth: textItem.width + 10

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
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
