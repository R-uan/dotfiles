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

  readonly property real unit: width / 20
  readonly property real artSize: height * 0.7

  // ── Blurred album art glow backdrop ──
  Image {
    id: bgBlur
    anchors.centerIn: parent
    width: parent.width * 1.2
    height: parent.height * 1.2
    fillMode: Image.PreserveAspectCrop
    source: img.source
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
    opacity: 0.15
    saturation: 0.5
  }

  // ── Main horizontal layout ──
  RowLayout {
    anchors.centerIn: parent
    width: parent.width * 0.90
    height: parent.height * 0.80
    spacing: root.unit * 0.9

    // ── Album art ──
    Item {
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredWidth: root.artSize
      Layout.preferredHeight: root.artSize

      // Soft glow behind art
      Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9
        radius: width / 2
        color: Qt.rgba(0.3, 0.5, 1.0, 0.10)
        layer.enabled: true
        layer.effect: MultiEffect {
          blurEnabled: true
          blur: 1.0
          blurMax: 28
        }
      }

      Image {
        id: img
        visible: false
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Quickshell.shellPath("assets/img/media-placeholder.jpg")
        Connections {
          target: player
          function onTrackArtUrlChanged() {
            if (player.trackArtUrl && player.trackArtUrl !== "")
              img.source = player.trackArtUrl;
          }
          function onTrackTitleChanged() {
            img.source = Quickshell.shellPath("assets/img/media-placeholder.jpg");
          }
        }
      }

      MultiEffect {
        source: img
        anchors.fill: img
        maskEnabled: true
        maskSource: artMask
        visible: img.status === Image.Ready
      }

      Item {
        id: artMask
        width: img.width
        height: img.height
        layer.enabled: true
        visible: false
        Rectangle {
          anchors.fill: parent
          radius: parent.width * 0.18
          color: "black"
        }
      }

      // Subtle inner border
      Rectangle {
        anchors.fill: parent
        radius: parent.width * 0.18
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.10)
        border.width: 1
      }
    }

    // ── Info + controls ──
    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: root.unit * 0.3

      // Track title
      StyledText {
        Layout.fillWidth: true
        font.pixelSize: root.unit * 0.85
        font.weight: Font.Medium
        font.letterSpacing: 0.3
        color: Qt.rgba(1, 1, 1, 0.92)
        elide: Text.ElideRight
        text: player?.trackTitle
                ? (player.trackTitle.length >= 28
                    ? player.trackTitle.slice(0, 24).trim() + "…"
                    : player.trackTitle)
                : "Thoughts"
      }

      // Artist name
      StyledText {
        Layout.fillWidth: true
        font.pixelSize: root.unit * 0.65
        font.letterSpacing: 1.6
        color: Qt.rgba(1, 1, 1, 0.40)
        elide: Text.ElideRight
        text: {
          if (!player?.trackArtist) return "YOUR MIND."
          let a = player.trackArtist
          return (a.length > 22 ? a.slice(0, 18).trim() + "…" : a).toUpperCase()
        }
      }

      // Controls
      RowLayout {
        spacing: root.unit * 0.45
        visible: player?.canControl ?? false
        Layout.topMargin: root.unit * 0.25

        // Prev
        Item {
          implicitWidth: root.unit * 1.9
          implicitHeight: root.unit * 1.9
          visible: player?.canGoPrevious ?? false

          Rectangle {
            anchors.fill: parent
            radius: parent.width / 2
            color: prevArea.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.05)
            border.color: Qt.rgba(1,1,1,0.09)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 120 } }
          }
          StyledText {
            anchors.centerIn: parent
            text: ""
            font.pixelSize: root.unit * 0.75
            color: Qt.rgba(1, 1, 1, 0.70)
          }
          MouseArea {
            id: prevArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: player?.previous()
            cursorShape: Qt.PointingHandCursor
          }
        }

        // Play / Pause
        Item {
          implicitWidth: root.unit * 2.4
          implicitHeight: root.unit * 2.4
          visible: player?.canPlay ?? false

          Rectangle {
            anchors.fill: parent
            radius: parent.width / 2
            color: playArea.containsMouse ? Qt.rgba(1,1,1,0.22) : Qt.rgba(1,1,1,0.12)
            border.color: Qt.rgba(1,1,1,0.16)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 120 } }
          }
          StyledText {
            anchors.centerIn: parent
            text: player?.isPlaying ? "" : ""
            font.pixelSize: root.unit * 0.92
            color: Qt.rgba(1, 1, 1, 0.95)
          }
          MouseArea {
            id: playArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: player?.togglePlaying()
            cursorShape: Qt.PointingHandCursor
          }
        }

        // Next
        Item {
          implicitWidth: root.unit * 1.9
          implicitHeight: root.unit * 1.9
          visible: player?.canGoNext ?? false

          Rectangle {
            anchors.fill: parent
            radius: parent.width / 2
            color: nextArea.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.05)
            border.color: Qt.rgba(1,1,1,0.09)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 120 } }
          }
          StyledText {
            anchors.centerIn: parent
            text: ""
            font.pixelSize: root.unit * 0.75
            color: Qt.rgba(1, 1, 1, 0.70)
          }
          MouseArea {
            id: nextArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: player?.next()
            cursorShape: Qt.PointingHandCursor
          }
        }
      }
    }
  }
}
