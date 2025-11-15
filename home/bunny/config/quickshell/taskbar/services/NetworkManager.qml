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
        command: [Qt.resolvedUrl("../scripts/getnetwork.sh")]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                for (let line of lines) {
                    if (line.startsWith("TYPE=")) {
                        let type = line.slice(5);
                        if (type == "disconnected")
                            root.connection = "󰶐  dc";
                        if (type == "ethernet")
                            root.connection = "  et";
                        if (type == "wifi")
                            root.connection = "  wf";
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
