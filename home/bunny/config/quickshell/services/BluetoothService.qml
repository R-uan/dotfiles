pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

// BlueZ state via bluetoothctl. (Quickshell.Bluetooth would be live, but on
// this machine it sees no adapters, so it stays on the CLI.)
Singleton {
  id: root

  property bool powered: false
  property bool scanning: false
  property var devices: []   // list of { mac, name, icon, paired, connected, trusted, battery }

  // Poll quickly only while someone is looking (the bluetooth menu).
  property bool watching: false

  // Device currently being acted on, and what's happening to it, so the UI
  // can show "connecting…" instead of a row that silently does nothing.
  property string busyMac: ""
  property string busyAction: ""      // "connecting" | "disconnecting" | "pairing" | "forgetting"
  property string lastError: ""

  readonly property int connectedCount: {
    let n = 0;
    for (let d of devices) if (d.connected) n++;
    return n;
  }

  readonly property var connectedDevices: devices.filter(d => d.connected)
  readonly property var pairedDevices: devices.filter(d => d.paired && !d.connected)
  readonly property var availableDevices: devices.filter(d => !d.paired && !d.connected)

  function refresh() { statusProc.running = true; }

  function _run(cmd, mac, action) {
    if (actionProc.running) return;
    root.busyMac = mac || "";
    root.busyAction = action || "";
    root.lastError = "";
    actionProc.command = cmd;
    actionProc.running = true;
  }

  function togglePower() {
    _run(["bluetoothctl", "power", root.powered ? "off" : "on"]);
  }

  // Not routed through _run: it must not block connects while it runs.
  function toggleScan() {
    scanProc.command = ["bluetoothctl", "--timeout", "15", "scan", root.scanning ? "off" : "on"];
    scanProc.running = true;
    root.scanning = !root.scanning;
  }

  function connect(mac)    { _run(["bluetoothctl", "connect", mac], mac, "connecting"); }
  function disconnect(mac) { _run(["bluetoothctl", "disconnect", mac], mac, "disconnecting"); }
  function forget(mac)     { _run(["bluetoothctl", "remove", mac], mac, "forgetting"); }

  // One chained command: three separate _run calls would overwrite each
  // other on the single Process and only the first would ever run.
  function pairAndConnect(mac) {
    _run(["sh", "-c",
          "bluetoothctl --timeout 25 pair \"$1\" && bluetoothctl trust \"$1\" && bluetoothctl connect \"$1\"",
          "sh", mac], mac, "pairing");
  }

  function activate(device) {
    if (!device) return;
    if (device.connected)   disconnect(device.mac);
    else if (device.paired) connect(device.mac);
    else                    pairAndConnect(device.mac);
  }

  Process {
    id: statusProc
    running: true
    command: [Config.scriptsDir + "/getbluetooth.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.split("\n");
        let powered = false, scanning = false;
        const devs = [];
        let inDevices = false;
        for (let line of lines) {
          if (line === "---DEVICES---") { inDevices = true; continue; }
          if (!inDevices) {
            if (line.startsWith("POWERED="))  powered  = (line.slice(8) === "yes");
            if (line.startsWith("SCANNING=")) scanning = (line.slice(9) === "yes");
          } else if (line.length > 0) {
            const parts = line.split("|");
            if (parts.length < 6) continue;
            const bat = parseInt(parts[6]);
            devs.push({
              mac:       parts[0],
              name:      parts[1] || parts[0],
              icon:      parts[2],
              paired:    parts[3] === "yes",
              connected: parts[4] === "yes",
              trusted:   parts[5] === "yes",
              battery:   isNaN(bat) ? -1 : bat
            });
          }
        }
        // Real names before bare MAC addresses, then alphabetical.
        const isMac = n => /^([0-9A-F]{2}[:-]){5}[0-9A-F]{2}$/i.test(n);
        devs.sort((a, b) => {
          if (a.connected !== b.connected) return a.connected ? -1 : 1;
          if (a.paired    !== b.paired)    return a.paired    ? -1 : 1;
          if (isMac(a.name) !== isMac(b.name)) return isMac(a.name) ? 1 : -1;
          return a.name.localeCompare(b.name);
        });
        root.powered  = powered;
        root.scanning = scanning;
        root.devices  = devs;
      }
    }
  }

  Process {
    id: actionProc
    running: false
    stderr: StdioCollector { id: actionErr }
    onExited: (code) => {
      if (code !== 0 && root.busyAction.length > 0)
        root.lastError = root.busyAction.replace(/ing$/, "") + " failed"
          + (actionErr.text.trim().length ? ": " + actionErr.text.trim().split("\n").pop() : "");
      root.busyMac = "";
      root.busyAction = "";
      root.refresh();
    }
  }

  Process {
    id: scanProc
    running: false
    onExited: root.refresh()
  }

  // Clear a stale error after a while.
  Timer {
    interval: 6000
    running: root.lastError.length > 0
    onTriggered: root.lastError = ""
  }

  Timer {
    interval: root.watching ? 2000 : 8000
    running: true
    repeat: true
    onTriggered: statusProc.running = true
  }
}
