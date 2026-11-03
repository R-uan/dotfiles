import qs.shared
import qs.config
import qs.services
import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Services.Mpris

// Now playing, after caelestia's media card: blurred art behind a rounded
// card, art + track info, a draggable seek bar and a full control row.
// The chip at the top names the player; with several around, clicking it
// switches between them. Collapses to one line when nothing is playing.
Item {
  id: root
  readonly property MprisPlayer player: MediaService.player
  readonly property bool _has: player !== null

  implicitHeight: _has ? 168 : 44
  Behavior on implicitHeight { Anim { duration: Motion.fastSpatialDuration } }

  readonly property string _placeholder: Quickshell.shellPath("assets/img/media-placeholder.jpg")
  readonly property string _artSrc: player?.trackArtUrl || _placeholder

  // While dragging the seek bar, show where it will land instead of the
  // player's position.
  property real _dragPct: -1
  readonly property real _pct: _dragPct >= 0 ? _dragPct : MediaService.progress

  function _fmt(sec) {
    if (!sec || sec <= 0) return "0:00";
    const s = Math.floor(sec) % 60, m = Math.floor(sec / 60) % 60, h = Math.floor(sec / 3600);
    const pad = n => (n < 10 ? "0" + n : String(n));
    return (h > 0 ? h + ":" + pad(m) : m) + ":" + pad(s);
  }

  readonly property color _fg:  Qt.rgba(1, 1, 1, 0.95)
  readonly property color _sub: Qt.rgba(1, 1, 1, 0.60)
  readonly property color _dim: Qt.rgba(1, 1, 1, 0.38)

  // ── Rounded backdrop: tile colour + blurred art ─────────────────────
  Item {
    id: backdrop
    anchors.fill: parent
    visible: false
    layer.enabled: true

    Rectangle {
      anchors.fill: parent
      color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.04) : Qt.rgba(0, 0, 0, 0.04)
    }
    Image {
      id: bgArt
      anchors.centerIn: parent
      width: parent.width * 1.2
      height: parent.height * 1.6
      fillMode: Image.PreserveAspectCrop
      source: root._has ? root._artSrc : ""
      sourceSize.width: 256
      asynchronous: true
      visible: false
    }
    MultiEffect {
      anchors.fill: bgArt
      source: bgArt
      blurEnabled: true
      blur: 1.0
      blurMax: 64
      saturation: -0.6
      opacity: bgArt.status === Image.Ready ? 0.35 : 0
      Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration * 2 } }
    }
    // Keeps text readable over bright art.
    Rectangle {
      anchors.fill: parent
      gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.35) }
        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.10) }
      }
    }
  }
  MultiEffect {
    anchors.fill: backdrop
    source: backdrop
    maskEnabled: true
    maskSource: cardMask
  }
  Item {
    id: cardMask
    anchors.fill: parent
    layer.enabled: true
    visible: false
    Rectangle { anchors.fill: parent; radius: 12; color: "black" }
  }
  Rectangle {
    anchors.fill: parent
    radius: 12
    color: "transparent"
    border.width: 1
    border.color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06)
  }

  // ── Nothing playing ─────────────────────────────────────────────────
  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 14
    anchors.rightMargin: 14
    spacing: 10
    visible: !root._has
    opacity: root._has ? 0 : 1
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }

    StyledText {
      text: "󰝚"
      font.pixelSize: Config.fontSize + 2
      color: root._dim
    }
    StyledText {
      Layout.fillWidth: true
      text: "Nothing playing"
      font.pixelSize: Config.fontSize - 2
      color: root._sub
    }
  }

  // ── Player ──────────────────────────────────────────────────────────
  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    spacing: 8
    visible: root._has
    opacity: root._has ? 1 : 0
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }

    RowLayout {
      Layout.fillWidth: true
      spacing: 12

      // Album art
      Item {
        Layout.preferredWidth: 84
        Layout.preferredHeight: 84

        Image {
          id: art
          anchors.fill: parent
          fillMode: Image.PreserveAspectCrop
          source: root._artSrc
          sourceSize.width: 168
          asynchronous: true
          visible: false
        }
        MultiEffect {
          anchors.fill: art
          source: art
          maskEnabled: true
          maskSource: artMask
          opacity: art.status === Image.Ready ? 1 : 0
          Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
        }
        Item {
          id: artMask
          anchors.fill: parent
          layer.enabled: true
          visible: false
          Rectangle { anchors.fill: parent; radius: 10; color: "black" }
        }
        Rectangle {
          anchors.fill: parent
          radius: 10
          color: "transparent"
          border.width: 1
          border.color: Qt.rgba(1, 1, 1, 0.10)
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        spacing: 2

        // Player chip; click to switch when there's more than one.
        Rectangle {
          readonly property bool _multi: MediaService.players.length > 1
          Layout.bottomMargin: 4
          implicitWidth: chipRow.implicitWidth + 14
          implicitHeight: 18
          radius: 9
          color: chipMouse.containsMouse && _multi ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(1, 1, 1, 0.08)
          Behavior on color { CAnim {} }

          Row {
            id: chipRow
            anchors.centerIn: parent
            spacing: 5
            StyledText {
              text: (root.player?.identity || "player").toLowerCase()
              font.pixelSize: Config.fontSize - 5
              font.letterSpacing: 1.2
              color: root._sub
            }
            StyledText {
              visible: parent.parent._multi
              text: "󰓡 " + (MediaService.players.indexOf(root.player) + 1) + "/" + MediaService.players.length
              font.pixelSize: Config.fontSize - 5
              color: root._dim
            }
          }
          MouseArea {
            id: chipMouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: parent._multi
            cursorShape: Qt.PointingHandCursor
            onClicked: MediaService.cycle()
          }
        }

        StyledText {
          Layout.fillWidth: true
          text: root.player?.trackTitle || "Unknown track"
          font.pixelSize: Config.fontSize + 1
          font.weight: Font.Medium
          color: root._fg
          elide: Text.ElideRight
        }
        StyledText {
          Layout.fillWidth: true
          visible: text.length > 0
          text: root.player?.trackArtist ?? ""
          font.pixelSize: Config.fontSize - 2
          color: root._sub
          elide: Text.ElideRight
        }
        StyledText {
          Layout.fillWidth: true
          visible: text.length > 0
          text: root.player?.trackAlbum ?? ""
          font.pixelSize: Config.fontSize - 4
          color: root._dim
          elide: Text.ElideRight
        }
      }
    }

    // ── Seek bar ────────────────────────────────────────────────────
    Item {
      id: seek
      Layout.fillWidth: true
      Layout.preferredHeight: 14
      readonly property bool _can: MediaService.lengthValid && (root.player?.canSeek ?? false)
      readonly property bool _hot: seekMouse.containsMouse || seekMouse.pressed

      Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: seek._hot && seek._can ? 6 : 4
        radius: height / 2
        color: Qt.rgba(1, 1, 1, 0.12)
        Behavior on height { Anim { duration: Motion.fastSpatialDuration } }

        Rectangle {
          height: parent.height
          radius: parent.radius
          width: Math.max(parent.height, parent.width * root._pct)
          color: Qt.rgba(1, 1, 1, 0.80)
          Behavior on width {
            enabled: root._dragPct < 0
            Anim { curve: Motion.effects; duration: Motion.effectsDuration }
          }
        }
      }
      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: Math.max(0, Math.min(parent.width - width, parent.width * root._pct - width / 2))
        width: 12
        height: 12
        radius: 6
        color: root._fg
        scale: seek._hot && seek._can ? 1 : 0
        Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }
      }
      MouseArea {
        id: seekMouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: seek._can
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        function _at(x) { return Math.max(0, Math.min(1, x / width)); }
        onPressed: (mouse) => root._dragPct = _at(mouse.x)
        onPositionChanged: (mouse) => { if (pressed) root._dragPct = _at(mouse.x); }
        onReleased: {
          if (root.player) root.player.position = root._dragPct * MediaService.length;
          root._dragPct = -1;
        }
        onCanceled: root._dragPct = -1
      }
    }

    // ── Times + controls ────────────────────────────────────────────
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 36

      StyledText {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: root._fmt(root._pct * MediaService.length)
        font.pixelSize: Config.fontSize - 4
        color: root._sub
      }
      StyledText {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: MediaService.lengthValid ? root._fmt(MediaService.length) : "--:--"
        font.pixelSize: Config.fontSize - 4
        color: root._sub
      }

      Row {
        anchors.centerIn: parent
        spacing: 6

        MediaButton {
          icon: root.player?.shuffle ? "󰒝" : "󰒞"
          active: root.player?.shuffle ?? false
          enabled: root.player?.shuffleSupported ?? false
          onClicked: root.player.shuffle = !root.player.shuffle
        }
        MediaButton {
          icon: "󰒮"
          enabled: root.player?.canGoPrevious ?? false
          onClicked: MediaService.previous()
        }
        MediaButton {
          size: 36
          primary: true
          icon: root.player?.isPlaying ? "󰏤" : "󰐊"
          enabled: root.player?.canTogglePlaying ?? false
          onClicked: MediaService.togglePlaying()
        }
        MediaButton {
          icon: "󰒭"
          enabled: root.player?.canGoNext ?? false
          onClicked: MediaService.next()
        }
        MediaButton {
          readonly property int _loop: root.player?.loopState ?? MprisLoopState.None
          icon: _loop === MprisLoopState.Track ? "󰑘" : _loop === MprisLoopState.Playlist ? "󰑖" : "󰑗"
          active: _loop !== MprisLoopState.None
          enabled: root.player?.loopSupported ?? false
          // none -> playlist -> track -> none
          onClicked: root.player.loopState = _loop === MprisLoopState.None ? MprisLoopState.Playlist
                                           : _loop === MprisLoopState.Playlist ? MprisLoopState.Track
                                           : MprisLoopState.None
        }
      }
    }
  }

  component MediaButton: Item {
    id: btn
    property string icon
    property int size: 28
    property bool primary: false
    property bool active: false
    signal clicked()

    width: size
    height: size
    opacity: enabled ? 1 : 0.3

    Rectangle {
      anchors.fill: parent
      radius: width / 2
      color: btn.primary ? (btnMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.95) : Qt.rgba(1, 1, 1, 0.85))
           : btnMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.12) : "transparent"
      Behavior on color { CAnim {} }
    }
    StyledText {
      anchors.centerIn: parent
      text: btn.icon
      font.pixelSize: btn.primary ? 18 : 15
      color: btn.primary ? "#151515" : btn.active ? root._fg : root._sub
      Behavior on color { CAnim {} }
    }
    scale: btnMouse.pressed ? 0.88 : 1
    Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }

    MouseArea {
      id: btnMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: btn.clicked()
    }
  }
}
