import "../services/"
import "../components"

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import ".."

RowLayout {
    implicitHeight: parent.height

    Rectangle {
        property string dynText

        radius: 4
        border.width: 1
        opacity: Theme.backgroundOpacity
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: textItem.width + 24
        color: mouseArea.containsMouse ? Theme.accent : Theme.dark
        border.color: mouseArea.containsMouse ? Theme.dark : Theme.darkLight

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
}
