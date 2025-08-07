import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import ".."

Rectangle {
    topLeftRadius: 2
    topRightRadius: 2
    bottomLeftRadius: 2
    bottomRightRadius: 2
    border.color: Theme.borderColor
    opacity: Theme.backgroundOpacity
    color: hoverHandler.hovered ? Theme.accent : Theme.dark

    Layout.alignment: Qt.AlignCenter
    Layout.preferredHeight: parent.height
    Layout.preferredWidth: textItem.width + 16

    property string dynText

    HoverHandler {
        id: hoverHandler
    }

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    CommonText {
        id: textItem
        text: dynText
        anchors.centerIn: parent
        color: hoverHandler.hovered ? Theme.dark : Theme.foreground
    }
}
