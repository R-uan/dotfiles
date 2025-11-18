import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.taskbar
import qs.taskbar.modules
import qs.taskbar.shared
import qs.taskbar.modules

// Right Section
Rectangle {
    id: root
    color: "transparent"
    radius: Theme.radius
    height: parent.height
    implicitWidth: layout.implicitWidth + 6

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 3
        spacing: 3

        Tray { Layout.preferredHeight: parent.height - 6 }

        // Separator {}

        SysResources { Layout.minimumHeight: parent.height - 6 }

        // Separator {}

        RowLayout {
            spacing: 3
            Layout.preferredHeight: parent.height
            // Network { Layout.minimumHeight: parent.height - 6 }

            // Volume { Layout.minimumHeight: parent.height - 6 }
        }
    }
}
