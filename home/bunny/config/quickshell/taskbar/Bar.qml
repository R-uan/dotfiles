import "."
import "shared"
import "sections"
import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets

// =====================
//  Status Bar (Panel)
// =====================
PanelWindow {
    id: bar
    visible: true
    color: "transparent"
    implicitHeight: Theme.height
    implicitWidth: Theme.barWidth
    objectName: "Status Bar Window"


    anchors {
        top: true
    }

    margins {
        top: 0
        bottom: -4
        left: Theme.margins
        right: Theme.margins
    }

    Rectangle {
        anchors.fill: parent
        bottomLeftRadius: Theme.radius
        bottomRightRadius: Theme.radius
        opacity: Theme.backgroundOpacity
        color: Theme.fullBar ? Theme.background : "transparent"
    }

    // ---- LEFT ----
    LeftSection {
        id: left
        anchors {
            leftMargin: 3
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        height: parent.height - 6
    }

    // ---- CENTER ----
    MiddleSection {
        id: middle
        height: parent.height - 6
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }

    // ---- RIGHT ----
    RightSection {
        id: right
        height: parent.height - 6
        anchors {
            rightMargin: 3
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
    }

}
