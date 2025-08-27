import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import "./common"
import "./services"
import "."

RowLayout {
    spacing: 3

    Repeater {
        model: SysResourcesManager.stats
        delegate: Rectangle {
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

            HoverHandler {
                id: hoverHandler
            }

            CommonText {
                id: textItem
                text: modelData
                anchors.centerIn: parent
                color: hoverHandler.hovered ? Theme.dark : Theme.foreground
            }
        }
    }
}
