import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import "../components"
import "../services"

RowLayout {
    implicitHeight: parent.height
    spacing: 7

    CommonHover {
        dynText: SysResourcesManager.cpuUsage
    }

    CommonText {
        text: "♥"
    }

    CommonHover {
        dynText: SysResourcesManager.ramUsage
    }

    CommonText {
        text: "♥"
    }

    CommonHover {
        dynText: SysResourcesManager.sysTemp
    }
}
