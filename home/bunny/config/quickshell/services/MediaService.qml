pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// Picks the MPRIS player the widgets should follow: whichever is playing,
// otherwise the first one around. `values[0]` alone would stick to a paused
// browser tab while Spotify plays in the background.
Singleton {
  id: root

  readonly property var players: Mpris.players.values || []
  readonly property MprisPlayer player: players.find(p => p.isPlaying) ?? players[0] ?? null

  readonly property bool hasPlayer: player !== null
  readonly property real position: player?.position ?? 0
  readonly property real _rawLen: player?.length ?? 0
  // Some MPRIS players report absurd length values when metadata is missing.
  readonly property bool lengthValid: _rawLen > 0 && _rawLen < 86400
  readonly property real length: lengthValid ? _rawLen : 0
  readonly property real progress: lengthValid ? Math.min(1, position / length) : 0

  // MPRIS doesn't push position updates; poke the binding while playing.
  Timer {
    interval: 1000
    running: root.player?.isPlaying ?? false
    repeat: true
    onTriggered: if (root.player) root.player.positionChanged()
  }

  function togglePlaying() { if (root.player?.canTogglePlaying) root.player.togglePlaying(); }
  function next()          { if (root.player?.canGoNext) root.player.next(); }
  function previous()      { if (root.player?.canGoPrevious) root.player.previous(); }
}
