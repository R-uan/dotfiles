pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../components"
import Quickshell.Services.SystemTray
import ".."

Item {
    id: root

    clip: true
    implicitWidth: layout.width + 10
    visible: width > 0 && height > 0
    implicitHeight: layout.implicitHeight

    required property QsWindow barWindow
    readonly property Repeater items: items

    Rectangle {
        color: "transparent"
        anchors.fill: parent
        border.color: Theme.borderColor
    }

    Row {
        id: layout

        spacing: 3
        anchors.right: root.right
        anchors.centerIn: root
        layoutDirection: Qt.RightToLeft

        add: Transition {
            NumberAnimation {
                to: 1
                from: 0
                duration: 1
                properties: "scale"
                easing.type: Easing.BezierSpline
            }
        }

        move: Transition {
            NumberAnimation {
                to: 1
                duration: 1
                properties: "scale"
                easing.bezierCurve: 2
                easing.type: Easing.BezierSpline
            }
            NumberAnimation {
                duration: 1
                properties: "x,y"
                easing.bezierCurve: 2
                easing.type: Easing.BezierSpline
            }
        }

        Repeater {
            id: items
            delegate: TrayItem {
                window: root.barWindow
            }
            model: SystemTray.items
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 1
            easing.bezierCurve: 2
            easing.type: Easing.BezierSpline
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 1
            easing.bezierCurve: 2
            easing.type: Easing.BezierSpline
        }
    }
}
