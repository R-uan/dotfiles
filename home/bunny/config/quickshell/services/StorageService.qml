pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // List of { dev, mount, label, used, total, percent }
  property var disks: []

  function friendlyLabel(dev, mount) {
    if (mount === "/") return "root";
    if (mount === "/home") return "home";
    const parts = mount.split("/").filter(function (p) { return p.length > 0; });
    return parts.length > 0 ? parts[parts.length - 1] : dev;
  }

  Process {
    id: storageProc
    running: true
    command: [Config.scriptsDir + "/getstorage.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const out = [];
        const lines = text.trim().split("\n");
        for (let line of lines) {
          if (!line) continue;
          const parts = line.split("|");
          if (parts.length < 4) continue;
          const dev = parts[0];
          const mount = parts[1];
          const used = parseFloat(parts[2]);
          const total = parseFloat(parts[3]);
          if (!(total > 0)) continue;
          out.push({
            dev: dev,
            mount: mount,
            label: root.friendlyLabel(dev, mount),
            used: used,
            total: total,
            percent: used / total
          });
        }
        root.disks = out;
      }
    }
  }

  Timer {
    interval: 15000
    running: true
    repeat: true
    onTriggered: storageProc.running = true
  }
}
