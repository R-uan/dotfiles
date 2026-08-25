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

  // Legacy fields used by any existing consumer (kept as strings)
  property string sysTemp: "??"
  property string ramUsage: "??"
  property string cpuUsage: "??"
  property var stats: []

  function _gib(bytes) { return bytes / (1024 * 1024 * 1024); }
  function _fmtGiB(bytes) {
    const g = _gib(bytes);
    return (g >= 10 ? g.toFixed(1) : g.toFixed(2)) + " GiB";
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

        root.cpu           = parseInt(kv.CPU) || 0;
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

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: statsProc.running = true
  }
}
