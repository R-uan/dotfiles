import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell

Rectangle {
    property string dynText

    radius: 4
    color: hoverHandler.hovered ? "#AC82E9" : "transparent"

    Layout.alignment: Qt.AlignCenter
    Layout.preferredHeight: parent.height
    Layout.preferredWidth: textItem.width + 16

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
    }
}
