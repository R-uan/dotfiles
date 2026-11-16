pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Thin wrapper around `warp-cli` for toggling Cloudflare WARP.
// Polls `warp-cli status` so the bar/menu reflect the daemon's actual state
// (the daemon can also be toggled from outside, e.g. the GUI client).
Singleton {
  id: root

  // "Connected" | "Disconnected" | "Connecting" | "Disconnecting" |
  // "Registration Missing" | "Unknown"
  property string statusText: "Unknown"
  property bool busy: false

  readonly property bool connected: statusText === "Connected"
  readonly property bool transitioning: statusText === "Connecting" || statusText === "Disconnecting"
  readonly property string icon: {
    if (transitioning) return "󰌙";
    return connected ? "󰦝" : "󰦞";
  }
  readonly property string shortLabel: {
    if (transitioning) return statusText.toLowerCase();
    return connected ? "warp on" : "warp off";
  }

  function toggle() {
    if (busy || transitioning) return;
    busy = true;
    toggleProc.command = ["warp-cli", connected ? "disconnect" : "connect"];
    toggleProc.running = true;
  }

  function refresh() { statusProc.running = true; }

  Process {
    id: statusProc
    running: true
    command: ["warp-cli", "--accept-tos", "status"]
    stdout: StdioCollector {
      onStreamFinished: {
        // warp-cli status prints e.g. "Status update: Connected\nNetwork: healthy"
        const m = text.match(/Status update:\s*([^\n]+)/);
        if (m) root.statusText = m[1].trim();
        else root.statusText = "Unknown";
      }
    }
  }

  Process {
    id: toggleProc
    running: false
    onExited: {
      root.busy = false;
      // Daemon flips through Connecting/Disconnecting before settling;
      // give it a beat, then poll a few times to catch the final state.
      settleTimer.restart();
    }
  }

  Timer {
    id: settleTimer
    interval: 400
    repeat: true
    property int ticks: 0
    onTriggered: {
      root.refresh();
      ticks += 1;
      if (ticks >= 6 && !root.transitioning) { ticks = 0; stop(); }
      if (ticks >= 12) { ticks = 0; stop(); }
    }
    onRunningChanged: if (!running) ticks = 0
  }

  // Background heartbeat so external changes (GUI, daemon restart) are picked up.
  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }
}
