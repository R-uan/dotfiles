pragma Singleton

import QtQuick
import Quickshell

// State for the on-screen display (windows/osd). Volume and mic mute are
// picked up straight from PipeWire, so media keys, pavucontrol and the bar
// all get the same feedback; other widgets call show() themselves.
Singleton {
  id: root

  property string icon: ""
  property string label: ""
  property real value: 0          // 0..1, the bar fill
  property string valueText: ""
  property bool dimmed: false
  property bool showBar: true
  property int revision: 0        // bumps on every show(), the window watches it

  // PipeWire settles default devices and volumes right after startup; don't
  // flash the OSD for that.
  property bool _armed: false
  Timer {
    interval: 2000
    running: true
    onTriggered: root._armed = true
  }

  function show(icon, label, value, valueText, dimmed, showBar) {
    if (!root._armed) return;
    root.icon = icon;
    root.label = label;
    root.value = Math.max(0, Math.min(1, value));
    root.valueText = valueText;
    root.dimmed = dimmed ?? false;
    root.showBar = showBar ?? true;
    root.revision++;
  }

  function _showVolume() {
    root.show(AudioService.icon, "Volume", AudioService.volume / 100,
              AudioService.muted ? "muted" : AudioService.volume + "%",
              AudioService.muted);
  }

  function _showMic() {
    root.show(AudioService.micIcon, "Microphone", AudioService.micVolume / 100,
              AudioService.micMuted ? "muted" : AudioService.micVolume + "%",
              AudioService.micMuted);
  }

  Connections {
    target: AudioService.sink ? AudioService.sink.audio : null
    ignoreUnknownSignals: true
    function onVolumeChanged() { root._showVolume(); }
    function onMutedChanged()  { root._showVolume(); }
  }

  Connections {
    target: AudioService.source ? AudioService.source.audio : null
    ignoreUnknownSignals: true
    function onMutedChanged() { root._showMic(); }
  }
}
