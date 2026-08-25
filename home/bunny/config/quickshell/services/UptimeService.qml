pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property string uptime: "…"

  Process {
    id: uptimeProc
    running: true
    command: [Config.scriptsDir + "/getuptime.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const line = text.trim();
        if (line.length > 0) root.uptime = line;
      }
    }
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: uptimeProc.running = true
  }
}
