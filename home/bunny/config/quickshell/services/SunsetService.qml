pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Thin wrapper around hyprsunset's IPC (`hyprctl hyprsunset ...`).
// hyprsunset doesn't report whether identity is active, so `enabled` is
// tracked here and the last temperature is kept to restore on re-enable.
Singleton {
  id: root

  readonly property int minTemp: 1000
  readonly property int maxTemp: 6500
  readonly property int minGamma: 10
  readonly property int maxGamma: 100

  property bool enabled: true
  property int temperature: 6000
  property int gamma: 100

  readonly property string icon: enabled ? "󰖔" : "󰖙"

  function setTemperature(t) {
    root.temperature = Math.round(Math.max(minTemp, Math.min(maxTemp, t)));
    root.enabled = true;
    tempDebounce.restart();
  }

  function stepTemperature(delta) {
    setTemperature(root.temperature + delta);
  }

  function setGamma(g) {
    root.gamma = Math.round(Math.max(minGamma, Math.min(maxGamma, g)));
    gammaDebounce.restart();
  }

  function toggle() {
    root.enabled = !root.enabled;
    if (root.enabled)
      Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", String(root.temperature)]);
    else
      Quickshell.execDetached(["hyprctl", "hyprsunset", "identity"]);
  }

  // Slider drags fire many updates; only send the latest value.
  Timer {
    id: tempDebounce
    interval: 40
    onTriggered: Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", String(root.temperature)])
  }

  Timer {
    id: gammaDebounce
    interval: 40
    onTriggered: Quickshell.execDetached(["hyprctl", "hyprsunset", "gamma", String(root.gamma)])
  }

  Process {
    running: true
    command: ["hyprctl", "hyprsunset", "temperature"]
    stdout: StdioCollector {
      onStreamFinished: {
        const t = parseInt(text.trim());
        if (!isNaN(t)) root.temperature = t;
      }
    }
  }

  Process {
    running: true
    command: ["hyprctl", "hyprsunset", "gamma"]
    stdout: StdioCollector {
      onStreamFinished: {
        const g = parseInt(text.trim());
        if (!isNaN(g)) root.gamma = g;
      }
    }
  }
}
