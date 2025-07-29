import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import "../components"
import "../services"

RowLayout {
    implicitHeight: parent.height
    spacing: 2
    SysResourceItem {
        dynText: SysResourcesManager.cpuUsage
    }

    SysResourceItem {
        dynText: SysResourcesManager.ramUsage
    }

    SysResourceItem {
        dynText: SysResourcesManager.sysTemp
    }
}
