pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property var imagePaths: []

    function getImages() {
        listFiles.running = true;
    }

    function displayWallpaper(path) {
        setWallpaper.command = ["swww", "img", path, "-t", "wipe", "--transition-duration", "2"];
        setWallpaper.running = true;
    }

    Process {
        id: setWallpaper
    }

    Process {
        id: listFiles
        command: [Qt.resolvedUrl("../scripts/getwallpaths")]
        stdout: StdioCollector {
            onStreamFinished: {
                const split = this.text.trim().split("\n");
                root.imagePaths = split.filter(p => p.length > 0);
            }
        }
    }
}
