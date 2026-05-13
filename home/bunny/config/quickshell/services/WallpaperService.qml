// WeatherService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string wallpaperPath: ""

  Process {
    id: fetcher
    command: ["awww", "query"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        if (text) {
          let path = text.split(" ");
          root.wallpaperPath = path[path.length - 1].trim();
        }
      }
    }
  }

  // — Refresh every minute —
  Timer {
    repeat: true
    running: true
    interval: 60000
    onTriggered: fetcher.running = true
  }
}
