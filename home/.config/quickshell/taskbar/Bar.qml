import "."
import "shared"
import "sections"
import QtQuick
import Quickshell
import QtQuick.Layouts

// =====================
//  Status Bar (Panel)
// =====================
PanelWindow {
    id: root
    required property var modelData

    visible: true
    color: "transparent"
    implicitHeight: Theme.height
    objectName: "Status Bar Window"

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 7
        bottom: 0
        left: Theme.margins
        right: Theme.margins
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        border.width: Theme.barBorderWidth
        border.color: Theme.barBorderColor
        opacity: Theme.backgroundOpacity
        color: Theme.fullBar ? Theme.background : "transparent"
    }

    // ---- LEFT ----
    LeftSection {
        id: left
        anchors {
            left: parent.left
            leftMargin: 3
            verticalCenter: parent.verticalCenter
        }
        height: parent.height - 6
    }

    // ---- CENTER ----
    MiddleSection {
        id: middle
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        height: parent.height - 6
    }

    // ---- RIGHT ----
    RightSection {
        id: right
        anchors {
            right: parent.right
            rightMargin: 3
            verticalCenter: parent.verticalCenter
        }
        height: parent.height - 6
    }
}
