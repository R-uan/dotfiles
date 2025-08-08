import "./common"
import "./services"
import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts

Rectangle {
    radius: 2
    border.width: 1
    border.color: Theme.borderColor
    opacity: Theme.backgroundOpacity
    Layout.preferredWidth: textItem.width + 24
    color: mouseArea.containsMouse ? Theme.accent : Theme.dark

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    CommonText {
        id: textItem
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "ddd,  MMM d  ♥  HH:mm")
        color: mouseArea.containsMouse ? Theme.dark : Theme.foreground
    }
}
