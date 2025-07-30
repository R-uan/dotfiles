pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string connection: "󰶐  disc"
    property string connName: "Disconnected"

    Process {
        id: getNetwork
        running: true
        command: ["/home/rw1c/.config/quickshell/bar/scripts/getnetwork"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                for (let line of lines) {
                    if (line.startsWith("TYPE=")) {
                        let type = line.slice(5);
                        if (type == "disconnected")
                            root.connection = "󰶐  disc";
                        if (type == "ethernet")
                            root.connection = "  ethe";
                        if (type == "wifi")
                            root.connection = "  wifi";
                    }

                    if (line.startsWith("NAME="))
                        root.connName = line.slice(5);
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: getNetwork.running = true 
    }
}
