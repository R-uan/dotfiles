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
    width: row.width
   
    RowLayout {
        id: row
        spacing: 4
        height: root.height

        MenuButton {
            icon: ""
            size: 13
            commands: ["kitty", "--detach"]
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }

        MenuButton {
            icon: ""
            size: 13
            commands: ["kitty", "--detach"]
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }

        MenuButton {
            icon: ""
            size: 13
            Layout.rightMargin: 4
            commands: ["kitty", "--detach"]
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }
    }
}
