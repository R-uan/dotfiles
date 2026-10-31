pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // Percentages (0-100)
  property int cpu: 0
  property int ramPct: 0
  property int swapPct: 0
  property int gpu: 0
  property int gpuMemPct: 0

  // Raw values
  property real ramUsedBytes: 0
  property real ramTotalBytes: 0
  property real swapUsedBytes: 0
  property real swapTotalBytes: 0
  property int  gpuMemUsedMiB: 0
  property int  gpuMemTotalMiB: 0
  property int  cpuTemp: 0
  property int  gpuTemp: 0
  property bool hasGpu: false

  // Rolling percentages for the sparklines, oldest first (~2 minutes).
  readonly property int historyLength: 40
  property var cpuHistory: []
  property var ramHistory: []
  property var gpuHistory: []

  // Top processes by CPU: list of { name, cpu, mem }. Only sampled while
  // something asks for it (the resources card), since it costs a top run.
  property var topProcs: []
  property bool watchProcs: false

  // Legacy fields used by any existing consumer (kept as strings)
  property string sysTemp: "??"
  property string ramUsage: "??"
  property string cpuUsage: "??"
  property var stats: []

  property real _prevTotal: 0
  property real _prevIdle: 0

  function _gib(bytes) { return bytes / (1024 * 1024 * 1024); }
  function _fmtGiB(bytes) {
    const g = _gib(bytes);
    return (g >= 10 ? g.toFixed(1) : g.toFixed(2)) + " GiB";
  }
  function _push(list, value) {
    const out = list.slice(Math.max(0, list.length - root.historyLength + 1));
    out.push(value);
    return out;
  }
  // Nix wraps binaries as ".name-wrapped", which top truncates further.
  function _procName(cmd) {
    return cmd.replace(/^\./, "").replace(/-w(r(a(p\w*)?)?)?$/, "");
  }

  Process {
    id: statsProc
    running: true
    command: [Config.scriptsDir + "/systemstats.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const kv = {};
        for (let line of text.trim().split("\n")) {
          const idx = line.indexOf("=");
          if (idx < 0) continue;
          kv[line.slice(0, idx)] = line.slice(idx + 1);
        }

        const total = parseFloat(kv.CPU_TOTAL) || 0;
        const idle  = parseFloat(kv.CPU_IDLE)  || 0;
        const dt = total - root._prevTotal;
        if (root._prevTotal > 0 && dt > 0)
          root.cpu = Math.max(0, Math.min(100, Math.round(100 * (1 - (idle - root._prevIdle) / dt))));
        root._prevTotal = total;
        root._prevIdle  = idle;

        root.cpuTemp       = parseInt(kv.TEMP) || 0;

        root.ramUsedBytes  = parseFloat(kv.RAM_USED)  || 0;
        root.ramTotalBytes = parseFloat(kv.RAM_TOTAL) || 1;
        root.ramPct        = Math.round(100 * root.ramUsedBytes / root.ramTotalBytes);

        root.swapUsedBytes  = parseFloat(kv.SWAP_USED)  || 0;
        root.swapTotalBytes = parseFloat(kv.SWAP_TOTAL) || 1;
        root.swapPct        = Math.round(100 * root.swapUsedBytes / root.swapTotalBytes);

        root.hasGpu         = kv.HAS_GPU === "1";
        root.gpu            = parseInt(kv.GPU) || 0;
        root.gpuMemUsedMiB  = parseInt(kv.GMEM_USED_MIB)  || 0;
        root.gpuMemTotalMiB = parseInt(kv.GMEM_TOTAL_MIB) || 1;
        root.gpuMemPct      = Math.round(100 * root.gpuMemUsedMiB / root.gpuMemTotalMiB);
        root.gpuTemp        = parseInt(kv.GTEMP) || 0;

        root.cpuHistory = root._push(root.cpuHistory, root.cpu);
        root.ramHistory = root._push(root.ramHistory, root.ramPct);
        if (root.hasGpu) root.gpuHistory = root._push(root.gpuHistory, root.gpu);

        // Legacy strings
        root.cpuUsage = root.cpu + "%";
        root.ramUsage = _fmtGiB(root.ramUsedBytes);
        root.sysTemp  = root.cpuTemp + "°C";
        root.stats = [
          {label: "cpu", value: root.cpuUsage},
          {label: "ram", value: root.ramUsage},
          {label: "tem", value: root.sysTemp}
        ];
      }
    }
  }

  Process {
    id: procsProc
    running: false
    command: [Config.scriptsDir + "/gettopprocs.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const out = [];
        for (let line of text.trim().split("\n")) {
          const parts = line.split("|");
          if (parts.length < 3) continue;
          out.push({
            name: root._procName(parts[0]),
            cpu:  parseFloat(parts[1]) || 0,
            mem:  parseFloat(parts[2]) || 0
          });
        }
        root.topProcs = out;
      }
    }
  }

  onWatchProcsChanged: if (watchProcs) procsProc.running = true

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: {
      statsProc.running = true;
      if (root.watchProcs) procsProc.running = true;
    }
  }
}
