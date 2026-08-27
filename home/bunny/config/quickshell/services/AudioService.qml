pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// Audio state for the shell, backed by Quickshell's native PipeWire binding
// rather than shelling out to pactl, so everything here is live and writable.
Singleton {
  id: root

  readonly property bool ready: Pipewire.ready

  // ── Default devices ───────────────────────────────────────────────
  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource

  // Volume is exposed as 0-100 so no caller has to deal in floats.
  readonly property int  volume:    sink && sink.audio ? Math.round(sink.audio.volume * 100) : 0
  readonly property bool muted:     sink && sink.audio ? sink.audio.muted : true
  readonly property int  micVolume: source && source.audio ? Math.round(source.audio.volume * 100) : 0
  readonly property bool micMuted:  source && source.audio ? source.audio.muted : true

  readonly property string sinkName:   nodeLabel(sink)
  readonly property string sourceName: nodeLabel(source)

  // ── Device and stream lists ───────────────────────────────────────
  // node.type is a bitmask: Audio=1, Video=2, Stream=4, Source=8, Sink=16.
  // Masking on Audio is what keeps V4L2 webcams out of the input list.
  readonly property var sinks: (Pipewire.nodes.values || []).filter(n =>
    n && n.isSink && !n.isStream && (n.type & PwNodeType.Audio))
  readonly property var sources: (Pipewire.nodes.values || []).filter(n =>
    n && !n.isSink && !n.isStream && (n.type & PwNodeType.Audio))
  readonly property var streams: (Pipewire.nodes.values || []).filter(n =>
    n && n.isStream && n.isSink && (n.type & PwNodeType.Audio))

  // PipeWire only publishes live volume/mute data for nodes that something is
  // holding open, so bind every node the UI is able to show.
  PwObjectTracker {
    objects: root.sinks.concat(root.sources, root.streams)
  }

  readonly property string icon: {
    if (!sink || muted || volume <= 0) return "󰝟";
    if (volume < 34) return "󰕿";
    if (volume < 67) return "󰖀";
    return "󰕾";
  }

  readonly property string micIcon: micMuted ? "󰍭" : "󰍬"

  function nodeLabel(node) {
    if (!node) return "None";
    if (node.isStream) {
      const app = node.properties ? node.properties["application.name"] : "";
      return app || node.name || "Unknown";
    }
    return node.nickname || node.description || node.name || "Unknown";
  }

  // Rough device class from the node name — PipeWire keeps the form factor on
  // the device object, not on the node we get handed here.
  function nodeIcon(node) {
    if (!node) return "󰓃";
    const n = (node.name || "").toLowerCase();
    if (n.includes("bluez") || n.includes("headset") || n.includes("headphone"))
      return "󰋋";
    if (n.includes("hdmi") || n.includes("displayport"))
      return "󰍹";
    return "󰓃";
  }

  // ── Mutations ─────────────────────────────────────────────────────
  function _applyVolume(node, pct) {
    if (!node || !node.audio) return;
    node.audio.volume = Math.max(0, Math.min(1, pct / 100));
  }

  function setVolume(pct)             { _applyVolume(root.sink, pct); }
  function setMicVolume(pct)          { _applyVolume(root.source, pct); }
  function setStreamVolume(node, pct) { _applyVolume(node, pct); }

  // Turning the volume up while muted should be audible — matches what every
  // other desktop does with media keys and scroll wheels.
  function stepVolume(delta) {
    if (!root.sink || !root.sink.audio) return;
    if (delta > 0 && root.sink.audio.muted) root.sink.audio.muted = false;
    setVolume(root.volume + delta);
  }

  function toggleMute() {
    if (root.sink && root.sink.audio) root.sink.audio.muted = !root.sink.audio.muted;
  }
  function toggleMicMute() {
    if (root.source && root.source.audio) root.source.audio.muted = !root.source.audio.muted;
  }
  function toggleStreamMute(node) {
    if (node && node.audio) node.audio.muted = !node.audio.muted;
  }

  function setSink(node)   { if (node) Pipewire.preferredDefaultAudioSink = node; }
  function setSource(node) { if (node) Pipewire.preferredDefaultAudioSource = node; }
}
