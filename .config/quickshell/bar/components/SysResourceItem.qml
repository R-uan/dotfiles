import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import ".."

Rectangle {
    property string dynText

    opacity: 1
    border.width: 1
    color: hoverHandler.hovered ? Theme.accent : Theme.dark
    border.color: hoverHandler.hovered ? Theme.dark : Theme.darkLight

    topLeftRadius: 4
    topRightRadius: 30
    bottomLeftRadius: 30
    bottomRightRadius: 4

    Layout.alignment: Qt.AlignCenter
    Layout.preferredHeight: parent.height
    Layout.preferredWidth: textItem.width + 24

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
