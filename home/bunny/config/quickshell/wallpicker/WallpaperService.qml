pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
  id: root
  property var imagePaths: []
  property var topImages: []
  property var bottomImages: []

  function loadWallpapers() {
    listFiles.running = true;
  }

  function displayWallpaper(path) {
    setWallpaper.command = ["awww", "img", path, "-t", "wipe", "--transition-duration", "2"];
    setWallpaper.running = true;
  }

  Process {
    id: setWallpaper
  }

  Process {
    id: listFiles
    command: ["/mnt/hdd/Code/dotfiles/home/bunny/config/quickshell/wallpicker/getwallpaths.sh"]

    stdout: StdioCollector {
      onStreamFinished: {
        const split = this.text.trim().split("\n").filter(p => p.length > 0);

        let newTopImages = [];
        let newBottomImages = [];

        for (let i = 0; i < split.length; i++) {
          if (i % 2 == 0) {
            newTopImages.push(split[i]);
          } else {
            newBottomImages.push(split[i]);
          }
        }

        // Reassign to trigger QML change notifications
        root.topImages = newTopImages;
        root.bottomImages = newBottomImages;
      }
    }
  }
}
