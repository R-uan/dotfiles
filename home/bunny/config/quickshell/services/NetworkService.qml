pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // Legacy compatibility (still used by the taskbar item)
  property string connection: "󰶐 "
  property string connName: "Disconnected"

  // Enriched state
  property string netState: "disconnected" // "connected" | "disconnected"
  property string type: "disconnected"    // "wifi" | "ethernet" | "disconnected"
  property string device: ""
  property string ipAddress: ""
  property int    signalStrength: 0        // 0-100, only for wifi
  property bool   wifiEnabled: false

  property var    wifiNetworks: []         // list of { inUse, ssid, signal, security, saved, secure }
  property bool   scanning: false

  readonly property string icon: {
    if (netState !== "connected") return "󰤭";  // no wifi
    if (type === "ethernet")   return "";     // desktop / laptop
    if (type === "wifi") {
      if (signalStrength >= 80) return "󰤨";
      if (signalStrength >= 60) return "󰤥";
      if (signalStrength >= 40) return "󰤢";
      if (signalStrength >= 20) return "󰤟";
      return "󰤯";
    }
    return "󰶐";
  }

  function refresh() { statusProc.running = true; }

  function rescan() {
    scanProc.running = true;
    wifiListProc.running = true;
  }

  function toggleWifi() {
    toggleProc.command = ["nmcli", "radio", "wifi", root.wifiEnabled ? "off" : "on"];
    toggleProc.running = true;
  }

  function connectSaved(ssid) {
    connectProc.command = ["nmcli", "connection", "up", "id", ssid];
    connectProc.running = true;
  }

  function connectOpen(ssid) {
    connectProc.command = ["nmcli", "device", "wifi", "connect", ssid];
    connectProc.running = true;
  }

  function connectSecure(ssid, password) {
    if (!password || password.length === 0) return;
    connectProc.command = ["nmcli", "device", "wifi", "connect", ssid, "password", password];
    connectProc.running = true;
  }

  function disconnect() {
    if (root.device.length === 0) return;
    disconnectProc.command = ["nmcli", "device", "disconnect", root.device];
    disconnectProc.running = true;
  }

  Process {
    id: statusProc
    running: true
    command: [Config.scriptsDir + "/getnetwork.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        let state = "disconnected", type = "disconnected", name = "disc";
        let device = "", ip = "", sig = 0, wifi = false;
        for (let line of lines) {
          if (line.startsWith("STATE=")) state = line.slice(6);
          else if (line.startsWith("TYPE="))   type   = line.slice(5);
          else if (line.startsWith("NAME="))   name   = line.slice(5);
          else if (line.startsWith("DEVICE=")) device = line.slice(7);
          else if (line.startsWith("IP="))     ip     = line.slice(3);
          else if (line.startsWith("SIGNAL=")) { const v = line.slice(7); sig = v.length ? parseInt(v) : 0; }
          else if (line.startsWith("WIFI="))   wifi   = (line.slice(5) === "enabled");
        }
        root.netState    = state;
        root.type        = type;
        root.connName    = (name.length > 0) ? name : (state === "connected" ? "connected" : "Disconnected");
        root.device      = device;
        root.ipAddress   = ip;
        root.signalStrength = sig;
        root.wifiEnabled = wifi;

        // Legacy icon+label used by the taskbar item — keep for back-compat.
        if (state !== "connected")       root.connection = "󰶐 ";
        else if (type === "ethernet")    root.connection = " ";
        else if (type === "wifi")        root.connection = " ";
        else                              root.connection = "󰛳 ";
      }
    }
  }

  Process {
    id: wifiListProc
    running: false
    command: [Config.scriptsDir + "/getwifinets.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        const out = [];
        for (let line of lines) {
          if (!line) continue;
          const parts = line.split("|");
          if (parts.length < 5) continue;
          const sec = parts[3];
          out.push({
            inUse:    parts[0] === "1",
            ssid:     parts[1],
            signal:   parseInt(parts[2]) || 0,
            security: sec,
            secure:   sec.length > 0 && sec !== "--",
            saved:    parts[4] === "1"
          });
        }
        root.wifiNetworks = out;
        root.scanning = false;
      }
    }
  }

  Process {
    id: scanProc
    running: false
    command: ["nmcli", "device", "wifi", "rescan"]
    onStarted: root.scanning = true
    onExited: wifiListProc.running = true
  }

  Process {
    id: toggleProc
    running: false
    onExited: {
      root.refresh();
      if (root.wifiEnabled) wifiListProc.running = true;
    }
  }

  Process {
    id: connectProc
    running: false
    onExited: {
      root.refresh();
      wifiListProc.running = true;
    }
  }

  Process {
    id: disconnectProc
    running: false
    onExited: root.refresh()
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: statusProc.running = true
  }
}
