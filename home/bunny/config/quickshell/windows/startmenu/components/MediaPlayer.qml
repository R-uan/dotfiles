import qs.shared
import qs.config

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts
import Quickshell.Services.Mpris

Item {
  property MprisPlayer player: Mpris.players.values[0] ?? null
  Background {
    anchors.fill: parent
  }

  ColumnLayout {
    spacing: 17
    anchors.centerIn: parent

    // Image
    Item {
      Layout.preferredWidth: 170
      Layout.preferredHeight: 170
      Layout.alignment: Qt.AlignHCenter

      Image {
        id: img
        visible: false
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Quickshell.shellPath("assets/img/media-placeholder.jpg")

        Connections {
          target: player
          function onTrackArtUrlChanged() {
            if (player.trackArtUrl && player.trackArtUrl !== "") {
              img.source = player.trackArtUrl;
            }
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
        maskSource: mask
        visible: img.status == Image.Ready  // only show when loaded
      }

      Item {
        id: mask
        width: img.width
        height: img.height
        layer.enabled: true
        visible: false

        Rectangle {
          radius: 16
          color: "black"
          width: img.width
          height: img.height
        }
      }
    }

    // Info
    ColumnLayout {
      spacing: 0
      Layout.topMargin: 5
      Layout.alignment: Qt.AlignHCenter
      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: player?.trackTitle ? player.trackTitle.length >= 29 ? `${player.trackTitle.slice(0, 24).trim()
                                                                    }...` : player.trackTitle : "Thoughts"
      }

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: player?.trackArtist ? player.trackArtist.length > 25 ? `${player.trackArtist.slice(0, 20).trim()
                                                                     }...` : player.trackArtist : "Your mind."
      }
    }

    // Controls
    RowLayout {
      spacing: 12
      visible: player?.canControl
      Layout.alignment: Qt.AlignHCenter

      Item {
        implicitWidth: 30
        implicitHeight: 30

        MouseArea {
          anchors.fill: parent
          StyledText {
            anchors.centerIn: parent
            text: ""
            visible: player?.canGoPrevious
            font.pixelSize: Config.fontSize * 2
          }

          onClicked: {
            player?.previous();
          }
        }
      }

      Item {
        implicitWidth: 30
        implicitHeight: 30

        MouseArea {
          anchors.fill: parent
          StyledText {
            anchors.centerIn: parent
            text: player?.isPlaying ? "" : ""
            font.pixelSize: Config.fontSize * 2
            visible: player?.canPlay
          }

          onClicked: {
            player?.togglePlaying();
          }
        }
      }

      Item {
        implicitWidth: 30
        implicitHeight: 30

        MouseArea {
          anchors.fill: parent
          StyledText {
            anchors.centerIn: parent
            text: ""
            visible: player?.canGoNext
            font.pixelSize: Config.fontSize * 2
          }

          onClicked: {
            player?.next();
          }
        }
      }
    }
  }
}
