pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../components"
import Quickshell.Services.SystemTray

Item {
    id: root
    clip: true
    visible: width > 0 && height > 0 // To avoid warnings about being visible with no size
    implicitWidth: 100
    implicitHeight: layout.implicitHeight
    
    readonly property Repeater items: items
    required property QsWindow barWindow

    Row {
        id: layout
        spacing: 2
        layoutDirection: Qt.RightToLeft
        anchors.right: root.right

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

        Component.onCompleted: {
            console.log(root.mainWindow)
        }
        
        Repeater {
            id: items
            delegate: TrayItem {
                window: barWindow
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
