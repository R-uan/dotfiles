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

        Item {
            Layout.fillWidth: true
        }

        MenuButton {
            icon: ""
            size: 13
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.preferredHeight: parent.height
        }

        MenuButton {
            icon: ""
            size: 13
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.preferredHeight: parent.height
        }

        MenuButton {
            icon: ""
            size: 13
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.preferredHeight: parent.height
            Layout.rightMargin: 4
        }
    }
}
