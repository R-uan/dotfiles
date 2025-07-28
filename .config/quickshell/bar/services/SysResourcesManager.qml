import QtQuick
import Quickshell
import Quickshell.Io

pragma Singleton

Singleton {
    id: root

    property string sysTemp: "??"
    property string ramUsage: "??"
    property string cpuUsage: "??"
    
    Process {
        id: tempProc
        running: true
        command: ["/home/rw1c/.config/quickshell/bar/scripts/systemstats"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                for (let line of lines) {
                    if (line.startsWith("TEMP=")) root.sysTemp = line.slice(5)
                    else if (line.startsWith("CPU=")) root.cpuUsage = line.slice(4)
                    else if (line.startsWith("RAM=")) root.ramUsage = line.slice(4)
                }            
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: tempProc.running = true 
    }
}
