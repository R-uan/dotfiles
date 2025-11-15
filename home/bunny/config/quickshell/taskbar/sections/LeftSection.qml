import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import qs.taskbar
import qs.taskbar.modules
import qs.taskbar.shared

// Left Section
Rectangle {
    id: root
    height: parent.height
    color: Theme.background
    opacity: Theme.backgroundOpacity
    border.width: 0
    radius: Theme.radius

    RowLayout {
        id: layout
        spacing: 6
        anchors.fill: parent
        anchors.margins: 0

        Workspaces {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: parent.height - 6
        }
    }
}
