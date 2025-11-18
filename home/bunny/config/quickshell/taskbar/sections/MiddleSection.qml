import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.taskbar
import qs.taskbar.shared
import qs.taskbar.modules
import qs.taskbar.sections

// Middle Section
Rectangle {
    id: root
    radius: Theme.radius
    color: "transparent"
    height: parent.height
    required property QsWindow popup
    implicitWidth: clockRow.implicitWidth

    SystemClock {
        id: sysclock
        precision: SystemClock.Seconds
    }

    MouseArea {
        enabled: true
        anchors.fill: root
        hoverEnabled: true

        onEntered: {
        }

        onExited: {
        }
    }

    RowLayout {
        id: clockRow
        anchors.fill: parent
        anchors.margins: 3
        spacing: 15
        anchors.centerIn: parent

        CommonText {
            font.bold: true
            color: Theme.foreground
            font.pixelSize: Theme.fontSize
            Layout.alignment: Qt.AlignVCenter
            text: Qt.formatDateTime(sysclock.date, "  HH:mm")
        }

        CommonText {
            font.bold: true
            color: Theme.foreground
            font.pixelSize: Theme.fontSize
            Layout.alignment: Qt.AlignVCenter
            text: Qt.formatDateTime(sysclock.date, "󰃭  ddd, MMM dd")
        }
    }
}
