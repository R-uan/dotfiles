import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts
import Quickshell.Services.Mpris

import qs.shared

Item {
  property MprisPlayer player: Mpris.players.values[0] ?? null
  readonly property int margins: 20
  readonly property int maxWidth: 300
  readonly property int spacing: 7
  readonly property int iconWidth: 14
  readonly property int separatorWidth: 6
  readonly property int charsPerPx: 7
  readonly property bool hasArtist: player?.trackArtist !== undefined && player.trackArtist !== ""
  readonly property int availableWidth: hasArtist ? maxWidth - margins - iconWidth - separatorWidth - spacing
                                                    * 3 : maxWidth - margins - iconWidth - spacing * 2
  readonly property string artist: player?.trackArtist ?? ""
  readonly property string title: player?.trackTitle ?? "Thoughts"
  readonly property int totalChars: Math.floor(availableWidth / charsPerPx)
  readonly property int artistChars: hasArtist ? Math.floor(totalChars * 0.45) : 0
  readonly property int titleChars: hasArtist ? totalChars - artistChars : totalChars
  readonly property string artistDisplay: artist.length > artistChars ? artist.slice(0, artistChars - 3).trim(
                                                                          ) + "..." : artist
  readonly property string titleDisplay: title.length > titleChars ? title.slice(0, titleChars - 3).trim()
                                                                     + "..." : title
  width: Math.min(maxWidth, hasArtist ? margins + iconWidth + separatorWidth + spacing * 3
                                        + artistDisplay.length * charsPerPx + titleDisplay.length
                                        * charsPerPx : margins + iconWidth + spacing * 2
                                        + titleDisplay.length * charsPerPx)
  height: 30

  Background {
    anchors.fill: parent
  }

  RowLayout {
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 10
    anchors.right: parent.right
    anchors.rightMargin: 10
    spacing: 7

    StyledText {
      text: player?.isPlaying ? "" : "󰒲"
    }
    StyledText {
      text: artistDisplay
      visible: hasArtist
    }
    StyledText {
      text: "-"
      visible: hasArtist
    }
    StyledText {
      text: titleDisplay
    }
  }
}
