pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool powered: false
  property bool scanning: false
  property var devices: []   // list of { mac, name, icon, paired, connected, trusted }

  readonly property int connectedCount: {
    let n = 0;
    for (let d of devices) if (d.connected) n++;
    return n;
  }

  function refresh() { statusProc.running = true; }

  function togglePower() {
    actionProc.command = ["bluetoothctl", "power", root.powered ? "off" : "on"];
    actionProc.running = true;
  }

  function toggleScan() {
    actionProc.command = ["bluetoothctl", "--timeout", "15", "scan", root.scanning ? "off" : "on"];
    actionProc.running = true;
  }

  function connect(mac) {
    actionProc.command = ["bluetoothctl", "connect", mac];
    actionProc.running = true;
  }

  function disconnect(mac) {
    actionProc.command = ["bluetoothctl", "disconnect", mac];
    actionProc.running = true;
  }

  function pair(mac) {
    actionProc.command = ["bluetoothctl", "pair", mac];
    actionProc.running = true;
  }

  function trust(mac) {
    actionProc.command = ["bluetoothctl", "trust", mac];
    actionProc.running = true;
  }

  function forget(mac) {
    actionProc.command = ["bluetoothctl", "remove", mac];
    actionProc.running = true;
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
            devs.push({
              mac:       parts[0],
              name:      parts[1] || parts[0],
              icon:      parts[2],
              paired:    parts[3] === "yes",
              connected: parts[4] === "yes",
              trusted:   parts[5] === "yes"
            });
          }
        }
        // Sort: connected first, then paired, then by name
        devs.sort((a, b) => {
          if (a.connected !== b.connected) return a.connected ? -1 : 1;
          if (a.paired    !== b.paired)    return a.paired    ? -1 : 1;
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
    onExited: root.refresh()
  }

  Timer {
    interval: 4000
    running: true
    repeat: true
    onTriggered: statusProc.running = true
  }
}
