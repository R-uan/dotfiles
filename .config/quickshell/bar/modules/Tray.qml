import QtQuick
import "../components"
import Quickshell.Services.SystemTray

Item {
    id: root
    clip: true
    visible: width > 0 && height > 0 // To avoid warnings about being visible with no size
    implicitWidth: 100
    implicitHeight: layout.implicitHeight
    
    readonly property Repeater items: items

    Row {
        id: layout
        anchors.horizontalCenter: root.horizontalCenter
        spacing: 2

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
            delegate: TrayItem {}
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
