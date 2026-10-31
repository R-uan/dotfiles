pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

// Screen recording with wf-recorder. Started detached so a shell reload
// doesn't kill a recording; state is reconciled with `pidof wf-recorder`,
// which also picks up a recording that survived a reload.
Singleton {
  id: root

  property bool recording: false
  property int elapsed: 0           // seconds
  property string file: ""
  property bool withAudio: true

  readonly property string elapsedText: {
    const m = Math.floor(elapsed / 60), s = elapsed % 60;
    return m + ":" + (s < 10 ? "0" : "") + s;
  }

  // PipeWire exposes "<sink node name>.monitor" to pulse clients, which is
  // what wf-recorder's --audio wants for "what I hear".
  readonly property string _audioDevice: AudioService.sink ? AudioService.sink.name + ".monitor" : ""

  function _outPath() {
    return Config.recordingsDir + "/recording_"
      + Qt.formatDateTime(new Date(), "yyyy-MM-dd_HH.mm.ss") + ".mp4";
  }

  // mode: "screen" (focused monitor) or "region" (slurp)
  function start(mode) {
    if (root.recording) return;
    const out = root._outPath();
    const audio = root.withAudio && root._audioDevice.length > 0
      ? "--audio=" + root._audioDevice : "";
    const monitor = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "";
    // $1 out, $2 audio flag (may be empty), $3 monitor, $4 mode
    const script = `
      mkdir -p "$(dirname "$1")"
      if [ "$4" = region ]; then
        geom=$(slurp -d) || exit 0
        set -- "$1" "$2" "$3" "$4" -g "$geom"
      else
        set -- "$1" "$2" "$3" "$4" -o "$3"
      fi
      out=$1; audio=$2; shift 4
      exec wf-recorder "$@" $audio --pixel-format yuv420p -f "$out"`;
    Quickshell.execDetached(["sh", "-c", script, "sh", out, audio, monitor, mode]);
    root.file = out;
    root.elapsed = 0;
    // slurp may still be waiting for a selection; pidof decides.
    root._starting = true;
    pollTimer.restart();
  }

  // SIGINT lets wf-recorder finish writing the file.
  function stop() {
    Quickshell.execDetached(["pkill", "-INT", "-x", "wf-recorder"]);
  }

  function toggle(mode) {
    if (root.recording) root.stop();
    else root.start(mode || "region");
  }

  function openFolder() {
    Quickshell.execDetached(["xdg-open", Config.recordingsDir]);
  }

  Process {
    id: pidProc
    command: ["pidof", "wf-recorder"]
    onExited: (code) => {
      const running = code === 0;
      if (running && !root.recording) {
        root.recording = true;
        root._starting = false;
      } else if (!running && root.recording) {
        root.recording = false;
        if (root.file.length > 0)
          Quickshell.execDetached(["notify-send", "-a", "Recorder", "Recording saved",
                                   root.file.split("/").pop() + " (" + root.elapsedText + ")"]);
      }
    }
  }

  // Every second while recording (it drives the timer) and right after
  // start(), while slurp may still be waiting; otherwise just a slow check
  // for recordings started outside the shell.
  property bool _starting: false
  Timer {
    interval: 30000
    running: root._starting
    onTriggered: root._starting = false
  }

  Timer {
    id: pollTimer
    interval: root.recording || root._starting ? 1000 : 5000
    repeat: true
    running: true
    onTriggered: {
      if (root.recording) root.elapsed++;
      pidProc.running = true;
    }
  }

  IpcHandler {
    target: "recorder"
    function toggle(): void { root.toggle("region"); }
    function screen(): void { root.toggle("screen"); }
    function region(): void { root.toggle("region"); }
    function stop(): void   { root.stop(); }
  }
}
