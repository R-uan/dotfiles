import Quickshell
import QtQuick
import Quickshell.Io

pragma Singleton

Singleton {
    id: root

    property var imagePaths: []

    function getImages() {
        listFiles.running = true
    }

    function displayWallpaper(path) {
        console.log(path)
        setWallpaper.command = ["swww", "img", path, "-t", "wipe", "--transition-duration", "2"]
        setWallpaper.running = true
    }

    Process {
        id: setWallpaper
    }

    Process {
        id: listFiles
        command: ["/home/rw1c/.config/quickshell/bar/scripts/getwallpaths"]
        // command: ["kitty", "--detach"]
        stdout: StdioCollector {
            onStreamFinished: {
                const split = this.text.trim().split("\n")
                root.imagePaths = split.filter(p => p.length > 0)
            }
        }
    }
}
