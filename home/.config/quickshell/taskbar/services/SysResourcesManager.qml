pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string sysTemp: "??"
    property string ramUsage: "??"
    property string cpuUsage: "??"

    property var stats: [cpuUsage, ramUsage, sysTemp] // This will hold the system stats

    Process {
        id: tempProc
        running: true
        command: [Qt.resolvedUrl("../scripts/systemstats")]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                for (let line of lines) {
                    if (line.startsWith("TEMP="))
                        root.sysTemp = line.slice(5);
                    else if (line.startsWith("CPU="))
                        root.cpuUsage = line.slice(4);
                    else if (line.startsWith("RAM="))
                        root.ramUsage = line.slice(4);
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
