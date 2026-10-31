import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts

// On-screen display that slides out of the bar at mid height, e.g. on
// volume changes. Content comes from OsdService. Only the card takes input:
// hovering keeps it open and scrolling adjusts what it shows.
PanelWindow {
  id: osd
  color: "transparent"
  objectName: "OSD"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  WlrLayershell.namespace: "quickshell:osd"
  mask: Region { item: assembly }

  // Set by shell.qml: don't pop up over a menu that already shows the value.
  property bool suppress: false

  readonly property int _barWidth: Config.thickness + 10
  readonly property int _cornerRadius: Config.rounding
  readonly property int _cardWidth: 236
  readonly property int _cardHeight: 58
  readonly property color _cardColor: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
  readonly property color _fg:    Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _dim:   Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _muted: Config.darkMode ? ThemeDark.muted       : ThemeLight.muted

  // Anchored to the left edge only, so the layer shell centres it vertically.
  anchors.left: true
  implicitWidth: _barWidth + _cardWidth
  implicitHeight: _cardHeight + _cornerRadius * 2

  property bool _shown: false
  visible: _shown || assembly.width > 0

  Connections {
    target: OsdService
    function onRevisionChanged() {
      if (osd.suppress) return;
      osd._shown = true;
      hideTimer.restart();
    }
  }

  Timer {
    id: hideTimer
    interval: 1600
    onTriggered: {
      if (cardHover.hovered) restart();
      else osd._shown = false;
    }
  }

  // ── Card ───────────────────────────────────────────────────────
  // Same construction as the resources card: flat against the bar,
  // rounded on the right, unfurling out of the bar.
  Item {
    id: assembly
    x: osd._barWidth
    y: osd._cornerRadius
    width: osd._shown ? osd._cardWidth : 0
    height: osd._cardHeight
    clip: true
    opacity: osd._shown ? 1 : 0

    // Springs out, accelerates back in (no overshoot past zero width).
    Behavior on width {
      Anim {
        curve: osd._shown ? Motion.spatial : Motion.accel
        duration: osd._shown ? Motion.spatialDuration : Motion.exitDuration
      }
    }
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }

    HoverHandler { id: cardHover }

    // Scroll on the card to keep adjusting whatever it is showing.
    WheelHandler {
      onWheel: (event) => {
        const up = event.angleDelta.y > 0;
        if (OsdService.label === "Volume") AudioService.stepVolume(up ? 5 : -5);
        else if (OsdService.label === "Microphone") {
          // Mic volume isn't watched by OsdService (apps auto-adjust gain), so refresh by hand.
          AudioService.setMicVolume(AudioService.micVolume + (up ? 5 : -5));
          Qt.callLater(OsdService._showMic);
        }
        else return;
        hideTimer.restart();
      }
    }

    Rectangle {
      x: -osd._cornerRadius
      width: parent.width + osd._cornerRadius
      height: parent.height
      radius: osd._cornerRadius
      color: osd._cardColor
    }

    RowLayout {
      x: 12
      width: osd._cardWidth - 28
      height: parent.height
      spacing: 12

      // Icon tile
      Rectangle {
        Layout.preferredWidth: 34
        Layout.preferredHeight: 34
        radius: 9
        color: Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.05)
        border.color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
        border.width: 1

        StyledText {
          anchors.centerIn: parent
          text: OsdService.icon
          font.pixelSize: 17
          color: OsdService.dimmed ? osd._muted : osd._fg
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 6

        RowLayout {
          Layout.fillWidth: true
          spacing: 6

          StyledText {
            Layout.fillWidth: true
            text: OsdService.label.toUpperCase()
            font.pixelSize: Config.fontSize - 5
            font.letterSpacing: 1.4
            color: osd._dim
            elide: Text.ElideRight
          }
          StyledText {
            text: OsdService.valueText
            font.pixelSize: Config.fontSize - 3
            font.weight: Font.Medium
            color: OsdService.dimmed ? osd._muted : osd._fg
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 4
          visible: OsdService.showBar
          radius: 2
          color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.08)

          Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.max(parent.height, parent.width * OsdService.value)
            radius: parent.radius
            color: OsdService.dimmed ? osd._muted : osd._fg
            Behavior on width { Anim { duration: Motion.fastSpatialDuration } }
            Behavior on color { ColorAnimation { duration: 140 } }
          }
        }
      }
    }
  }

  // ── Fillets where the card meets the bar ──────────────────────
  readonly property real _filletOpacity:
    assembly.opacity * Math.min(1, assembly.width / (_cornerRadius * 2))

  RoundCorner {
    x: osd._barWidth
    y: 0
    implicitSize: osd._cornerRadius
    corner: RoundCorner.CornerEnum.BottomLeft
    color: osd._cardColor
    visible: osd._filletOpacity > 0.05
    opacity: osd._filletOpacity
  }

  RoundCorner {
    x: osd._barWidth
    y: osd._cornerRadius + osd._cardHeight
    implicitSize: osd._cornerRadius
    corner: RoundCorner.CornerEnum.TopLeft
    color: osd._cardColor
    visible: osd._filletOpacity > 0.05
    opacity: osd._filletOpacity
  }

  // ── IPC for keybinds ──────────────────────────────────────────
  //   qs -p ~/.config/quickshell ipc call audio up
  // Going through the shell (instead of wpctl) is what shows the OSD.
  IpcHandler {
    target: "audio"
    function up(): void      { AudioService.stepVolume(5); }
    function down(): void    { AudioService.stepVolume(-5); }
    function mute(): void    { AudioService.toggleMute(); }
    function micMute(): void { AudioService.toggleMicMute(); }
  }

  IpcHandler {
    target: "media"
    function playPause(): void { MediaService.togglePlaying(); }
    function next(): void      { MediaService.next(); }
    function previous(): void  { MediaService.previous(); }
  }
}
