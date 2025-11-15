pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string volumeDisplay: "??"
    property int volumeValue

    function setVolume(value) {
        if (volumeSetter.running)
            return;
        if (root.volumeValue >= 100 && value == "+5")
            value = "100";
        volumeSetter.command = [Qt.resolvedUrl("../scripts/setvolume.sh"), value];
        volumeSetter.running = true;
    }

    Process {
        id: getVolume
        running: true
        command: [Qt.resolvedUrl("../scripts/getvolume.sh")]
        stdout: StdioCollector {
            onStreamFinished: {
                let volume = parseInt(text.trim());
                root.volumeValue = volume;

                if (volume == NaN)
                    root.volumeDisplay = `󰟎  ???`;
                if (volume <= 0)
                    root.volumeDisplay = `󰟎  muted`;
                else
                    root.volumeDisplay = `  ${volume}%`;
            }
        }
    }

    Process {
        id: volumeSetter
        onRunningChanged: {
            if (!running) {
                getVolume.running = true;
            }
        }
    }
}
