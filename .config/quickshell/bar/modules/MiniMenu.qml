import QtQuick
import Quickshell
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import "../services"
import "../components"
import ".."

Item {
    id: root
    width: row.width + 12

    required property QsWindow rootWindow

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.borderColor
    }
           
    RowLayout {
        id: row
        spacing: 3
        height: root.height
        anchors.centerIn: parent

        MenuButton {
            icon: ""
            size: 13
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }

        WallpaperSelector {
            rootWindow: root.rootWindow
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }

        MenuButton {
            icon: ""
            size: 13
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }
    }
}
