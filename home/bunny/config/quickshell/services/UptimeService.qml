pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property string uptime: "…"        // "up 5 hours, 43 minutes"
  property string uptimeShort: "…"   // "5h 43m", "2d 3h"

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

  FileView {
    id: procUptime
    path: "/proc/uptime"
    onLoaded: {
      const up = Math.floor(parseFloat(text().split(" ")[0]) || 0);
      const d = Math.floor(up / 86400), h = Math.floor(up % 86400 / 3600), m = Math.floor(up % 3600 / 60);
      root.uptimeShort = d > 0 ? d + "d " + h + "h" : (h > 0 ? h + "h " + m + "m" : m + "m");
    }
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: {
      uptimeProc.running = true;
      procUptime.reload();
    }
  }
}
