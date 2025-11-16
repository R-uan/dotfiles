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
    height: parent.height
    color: Theme.background
    opacity: Theme.backgroundOpacity
    implicitWidth: clockRow.implicitWidth

    SystemClock {
        id: sysclock
        precision: SystemClock.Seconds
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
