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

  // ── Arrival times ─────────────────────────────────────────────
  // mako keeps no timestamps, so record when each notification first shows
  // up. mako's on-notify pings us over IPC (below), so that is effectively
  // the arrival time. Saved to the cache so reloads keep them.
  property var times: ({})          // key -> epoch ms
  property real now: Date.now()     // ticks so relative labels stay fresh
  property bool _timesLoaded: false

  // mako reuses ids after a restart; the summary keeps old stamps from
  // sticking to new notifications.
  function _key(n) {
    return n.id + "|" + (n.app_name || "") + "|" + String(n.summary || "").slice(0, 40);
  }

  function timeOf(n) { return n ? (root.times[root._key(n)] || 0) : 0; }

  function _stamp(lists) {
    const t = {};
    const stamp = Date.now();
    let changed = false;
    for (const list of lists) {
      for (const n of list) {
        const k = root._key(n);
        if (root.times[k]) t[k] = root.times[k];
        else { t[k] = stamp; changed = true; }
      }
    }
    // Entries mako no longer has are dropped, which also counts as a change.
    if (!changed && Object.keys(t).length === Object.keys(root.times).length) return;
    root.times = t;
    timesFile.setText(JSON.stringify(t));
  }

  FileView {
    id: timesFile
    path: Quickshell.cachePath("notification-times.json")
    printErrors: false
    onLoaded: {
      try { root.times = JSON.parse(text()) || {}; } catch (e) { root.times = {}; }
      root._timesLoaded = true;
      root.refresh();
    }
    // First run: nothing saved yet.
    onLoadFailed: {
      root._timesLoaded = true;
      root.refresh();
    }
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: root.now = Date.now()
  }

  // Called by mako's on-notify (config/mako/config) so new notifications
  // are stamped and shown right away instead of on the next poll.
  IpcHandler {
    target: "notifications"
    function arrived(): void { root.refresh(); }
  }

  function _safeParse(txt) {
    try { return JSON.parse(txt); } catch (e) { return []; }
  }

  function refresh() {
    if (root._timesLoaded) notifProc.running = true;
  }

  // Runs the notification's default action, then mako drops it.
  function invoke(id) {
    dismissProc.command = ["makoctl", "invoke", "-n", String(id)];
    dismissProc.running = true;
  }

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
    running: false   // started once the saved times are loaded
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
        root._stamp([root.active, root.history]);
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
      root.refresh();
      modeProc.running = true;
    }
  }
}
