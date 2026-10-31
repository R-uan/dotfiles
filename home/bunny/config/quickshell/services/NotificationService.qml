pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property var active: []
  property var history: []
  readonly property int activeCount: active.length
  readonly property int historyCount: history.length

  // mako's do-not-disturb mode (defined in config/mako/config).
  property bool dnd: false

  function _safeParse(txt) {
    try { return JSON.parse(txt); } catch (e) { return []; }
  }

  function refresh() { notifProc.running = true; }

  function dismiss(id) {
    dismissProc.command = ["makoctl", "dismiss", "-n", String(id)];
    dismissProc.running = true;
  }

  function dismissAll() {
    dismissProc.command = ["makoctl", "dismiss", "--all"];
    dismissProc.running = true;
  }

  function clearHistory() {
    clearHistoryProc.running = true;
  }

  function toggleDnd() {
    root.dnd = !root.dnd;   // optimistic, modeProc confirms
    dndProc.running = true;
  }

  Process {
    id: notifProc
    running: true
    command: [Config.scriptsDir + "/getnotifications.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const marker = text.indexOf("HISTORY");
        if (marker < 0) {
          root.active = [];
          root.history = [];
          return;
        }
        const activeChunk = text.slice(0, marker).replace(/^ACTIVE\s*/, "").trim();
        const historyChunk = text.slice(marker).replace(/^HISTORY\s*/, "").trim();
        root.active = root._safeParse(activeChunk);
        root.history = root._safeParse(historyChunk);
      }
    }
  }

  Process {
    id: modeProc
    running: true
    command: ["makoctl", "mode"]
    stdout: StdioCollector {
      onStreamFinished: root.dnd = text.split("\n").includes("do-not-disturb")
    }
  }

  Process {
    id: dndProc
    running: false
    command: ["makoctl", "mode", "-t", "do-not-disturb"]
    onExited: modeProc.running = true
  }

  Process {
    id: dismissProc
    running: false
    onExited: root.refresh()
  }

  Process {
    id: clearHistoryProc
    running: false
    command: [Config.scriptsDir + "/clearnotifhistory.sh"]
    onExited: root.refresh()
  }

  Timer {
    interval: 4000
    running: true
    repeat: true
    onTriggered: {
      notifProc.running = true;
      modeProc.running = true;
    }
  }
}
