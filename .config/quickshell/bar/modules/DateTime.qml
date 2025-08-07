import ".."
import "../services/"
import "../components"

import QtQuick
import QtQuick.Window
import QtQuick.Layouts


Rectangle {
    radius: 2
    border.width: 1
    border.color: Theme.borderColor
    opacity: Theme.backgroundOpacity
    Layout.preferredWidth: textItem.width + 24
    color: mouseArea.containsMouse ? Theme.accent : Theme.dark

    property string dynText

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
        text: DateTimeManager.time
        color: mouseArea.containsMouse ? Theme.dark : Theme.foreground
    }
}
