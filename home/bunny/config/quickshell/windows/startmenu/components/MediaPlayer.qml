import qs.shared
import qs.config
import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts
import Quickshell.Services.Mpris

Item {
  id: root
  property MprisPlayer player: Mpris.players.values[0] ?? null

  readonly property bool _hasPlayer: player !== null
  readonly property real _pos: player?.position ?? 0
  readonly property real _rawLen: player?.length ?? 0
  // Some MPRIS players report absurd length values when metadata is missing.
  readonly property bool _lenValid: _rawLen > 0 && _rawLen < 86400
  readonly property real _len: _lenValid ? _rawLen : 0
  readonly property real _pct: _lenValid ? Math.min(1, _pos / _len) : 0

  function _fmtTime(sec) {
    if (!sec || sec <= 0) return "0:00";
    const s = Math.floor(sec) % 60;
    const m = Math.floor(sec / 60) % 60;
    const h = Math.floor(sec / 3600);
    const pad = (n) => (n < 10 ? "0" + n : String(n));
    return (h > 0 ? h + ":" + pad(m) : m) + ":" + pad(s);
  }

  Timer {
    interval: 500
    running: root.player?.isPlaying ?? false
    repeat: true
    onTriggered: if (root.player) root.player.positionChanged()
  }

  // Blurred art backdrop
  Image {
    id: bgBlur
    anchors.centerIn: parent
    width: parent.width * 1.15
    height: parent.height * 1.15
    fillMode: Image.PreserveAspectCrop
    source: art.source
    visible: false
    cache: true
  }
  MultiEffect {
    source: bgBlur
    anchors.fill: bgBlur
    blurEnabled: true
    blur: 1.0
    blurMax: 64
    blurMultiplier: 2.0
    opacity: 0.18
    saturation: 0.4
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    spacing: 8

    // ── Top row: art + title/artist/controls ────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 12

      // Album art
      Item {
        Layout.preferredWidth: 64
        Layout.preferredHeight: 64
        Layout.alignment: Qt.AlignVCenter

        Image {
          id: art
          visible: false
          anchors.fill: parent
          fillMode: Image.PreserveAspectCrop
          source: Quickshell.shellPath("assets/img/media-placeholder.jpg")
          Connections {
            target: root.player
            function onTrackArtUrlChanged() {
              if (root.player.trackArtUrl && root.player.trackArtUrl !== "")
                art.source = root.player.trackArtUrl;
            }
            function onTrackTitleChanged() {
              art.source = Quickshell.shellPath("assets/img/media-placeholder.jpg");
            }
          }
        }

        MultiEffect {
          source: art
          anchors.fill: art
          maskEnabled: true
          maskSource: artMask
          visible: art.status === Image.Ready
        }

        Item {
          id: artMask
          width: art.width
          height: art.height
          layer.enabled: true
          visible: false
          Rectangle {
            anchors.fill: parent
            radius: 10
            color: "black"
          }
        }

        Rectangle {
          anchors.fill: parent
          radius: 10
          color: "transparent"
          border.color: Qt.rgba(1, 1, 1, 0.08)
          border.width: 1
        }
      }

      // Title / artist
      ColumnLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        spacing: 2

        StyledText {
          Layout.fillWidth: true
          font.pixelSize: Config.fontSize + 1
          font.weight: Font.Medium
          color: Qt.rgba(1, 1, 1, 0.95)
          elide: Text.ElideRight
          maximumLineCount: 1
          text: root.player?.trackTitle && root.player.trackTitle.length > 0
                  ? root.player.trackTitle
                  : "Nothing playing"
        }

        StyledText {
          Layout.fillWidth: true
          font.pixelSize: Config.fontSize - 3
          font.letterSpacing: 1.4
          color: Qt.rgba(1, 1, 1, 0.55)
          elide: Text.ElideRight
          maximumLineCount: 1
          text: root.player?.trackArtist && root.player.trackArtist.length > 0
                  ? root.player.trackArtist.toUpperCase()
                  : "—"
        }
      }

      // Play / Pause (main)
      Item {
        Layout.preferredWidth: 40
        Layout.preferredHeight: 40
        Layout.alignment: Qt.AlignVCenter
        visible: root.player?.canPlay ?? false

        Rectangle {
          anchors.fill: parent
          radius: width / 2
          color: playArea.containsMouse ? Qt.rgba(1,1,1,0.22) : Qt.rgba(1,1,1,0.14)
          border.color: Qt.rgba(1,1,1,0.14)
          border.width: 1
          Behavior on color { ColorAnimation { duration: 120 } }
        }
        StyledText {
          anchors.centerIn: parent
          text: root.player?.isPlaying ? "" : ""
          font.pixelSize: 16
          color: Qt.rgba(1, 1, 1, 0.95)
        }
        MouseArea {
          id: playArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.player?.togglePlaying()
          cursorShape: Qt.PointingHandCursor
        }
      }
    }

    // ── Seek bar + times ─────────────────────────────────────
    Item {
      Layout.fillWidth: true
      Layout.topMargin: 4
      Layout.preferredHeight: seekTrack.height + timeRow.implicitHeight + 4
      visible: root._hasPlayer

      Rectangle {
        id: seekTrack
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 3
        radius: 2
        color: Qt.rgba(1, 1, 1, 0.10)

        Rectangle {
          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: Math.max(2, parent.width * root._pct)
          radius: 2
          color: Qt.rgba(1, 1, 1, 0.80)
          Behavior on width { NumberAnimation { duration: 200 } }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          enabled: root._lenValid && (root.player?.canSeek ?? false)
          cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
          onClicked: (mouse) => {
            const p = mouse.x / width;
            if (root.player) root.player.position = p * root._len;
          }
        }
      }

      RowLayout {
        id: timeRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: seekTrack.bottom
        anchors.topMargin: 4
        spacing: 4

        StyledText {
          text: root._fmtTime(root._pos)
          font.pixelSize: Config.fontSize - 4
          color: Qt.rgba(1, 1, 1, 0.55)
        }
        Item { Layout.fillWidth: true }
        StyledText {
          text: root._lenValid ? root._fmtTime(root._len) : "--:--"
          font.pixelSize: Config.fontSize - 4
          color: Qt.rgba(1, 1, 1, 0.55)
        }
      }
    }

    // ── Prev / Next row ──────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      Layout.topMargin: 2
      spacing: 6
      visible: root.player?.canControl ?? false

      Item { Layout.fillWidth: true }

      // Prev
      Item {
        Layout.preferredWidth: 30
        Layout.preferredHeight: 30
        visible: root.player?.canGoPrevious ?? false

        Rectangle {
          anchors.fill: parent
          radius: width / 2
          color: prevArea.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.04)
          border.color: Qt.rgba(1,1,1,0.08)
          border.width: 1
          Behavior on color { ColorAnimation { duration: 120 } }
        }
        StyledText {
          anchors.centerIn: parent
          text: ""
          font.pixelSize: 12
          color: Qt.rgba(1, 1, 1, 0.70)
        }
        MouseArea {
          id: prevArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.player?.previous()
          cursorShape: Qt.PointingHandCursor
        }
      }

      // Next
      Item {
        Layout.preferredWidth: 30
        Layout.preferredHeight: 30
        visible: root.player?.canGoNext ?? false

        Rectangle {
          anchors.fill: parent
          radius: width / 2
          color: nextArea.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.04)
          border.color: Qt.rgba(1,1,1,0.08)
          border.width: 1
          Behavior on color { ColorAnimation { duration: 120 } }
        }
        StyledText {
          anchors.centerIn: parent
          text: ""
          font.pixelSize: 12
          color: Qt.rgba(1, 1, 1, 0.70)
        }
        MouseArea {
          id: nextArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.player?.next()
          cursorShape: Qt.PointingHandCursor
        }
      }

      Item { Layout.fillWidth: true }
    }
  }
}
