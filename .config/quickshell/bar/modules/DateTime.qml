import ".."
import "../services/"
import "../components"

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

RowLayout {
    implicitHeight: parent.height

    Rectangle {
        property string dynText

        radius: 4
        opacity: Theme.backgroundOpacity
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: textItem.width + 24
        color: mouseArea.containsMouse ? Theme.accent : Theme.dark

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
