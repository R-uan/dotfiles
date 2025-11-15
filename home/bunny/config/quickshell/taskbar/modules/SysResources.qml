import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import qs.taskbar
import qs.taskbar.services
import qs.taskbar.shared

RowLayout {
    spacing: Theme.spacing

    Repeater {
        model: SysResourcesManager.stats

        delegate: Rectangle {
            topLeftRadius: 2
            topRightRadius: 2
            bottomLeftRadius: 2
            bottomRightRadius: 2
            height: parent.height
            border.color: Theme.border
            opacity: Theme.backgroundOpacity
            color: hoverHandler.hovered ? Theme.primaryHover : Theme.background
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: textItem.width + 16

            HoverHandler {
                id: hoverHandler
            }

            CommonText {
                id: textItem

                text: modelData
                anchors.centerIn: parent
                color: hoverHandler.hovered ? Theme.foregroundHover : Theme.foreground
            }

        }

    }

}
