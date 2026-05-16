import qs.shared
import qs.config
import qs.services
import qs.windows.startmenu.components
import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

PanelWindow {
  id: quickMenu
  visible: false
  implicitWidth: 420
  color: "transparent"
  objectName: "Start Menu"
  height: mainLayout.implicitHeight
  exclusionMode: ExclusionMode.Normal

  anchors {
    top: true
    left: true
    right: false
  }

  margins {
    top: 6
    left: 6
    bottom: 6
  }

  Background {
    radius: 14
  }

  property alias timer: timer

  ColumnLayout {
    id: mainLayout
    spacing: 0
    width: parent.width

    // ── Wallpaper hero card ──────────────────────────────────────────────
    // Wrapped in a plain Item so the wallpaper button sits OUTSIDE the
    // clipping container and is always visible.
    Item {
      Layout.fillWidth: true
      Layout.topMargin: 14
      Layout.leftMargin: 14
      Layout.rightMargin: 14
      // Button overflows 32px below the card — account for that in height
      implicitHeight: cardClip.implicitHeight + 10

      // Clipping wrapper — only the image gets clipped
      Item {
        id: cardClip
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: Math.min(cardInner.implicitHeight, 155)
        clip: true

        Card {
          id: cardInner
          width: parent.width
        }
      }

      // Wallpaper picker button — outside clip, bottom-right of card
      Item {
        anchors.bottom: cardClip.bottom
        anchors.right: cardClip.right
        anchors.bottomMargin: 8
        anchors.rightMargin: 8
        width: 30
        height: 30
        z: 10

        Rectangle {
          anchors.fill: parent
          radius: 7
          color: wallpaperBtn.containsMouse ? Qt.rgba(0,0,0,0.60) : Qt.rgba(0,0,0,0.38)
          Behavior on color { ColorAnimation { duration: 120 } }
        }

        StyledText {
          text: ""
          font.pixelSize: 14
          anchors.centerIn: parent
          color: Qt.rgba(1, 1, 1, 0.88)
        }

        MouseArea {
          id: wallpaperBtn
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (wallpapers.visible) {
              wallpapers.visible = false
              wallpapers.timer.running = false
            } else {
              wallpapers.visible = true
            }
          }
        }
      }
    }

    // ── Folder shortcuts ─────────────────────────────────────────────────
    HomeShortcut {
      Layout.topMargin: 2
      Layout.bottomMargin: 2
      Layout.fillWidth: true
    }

    // ── Divider ──────────────────────────────────────────────────────────
    Rectangle {
      Layout.fillWidth: true
      Layout.leftMargin: 14
      Layout.rightMargin: 14
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // ── Media player ─────────────────────────────────────────────────────
    MediaPlayer {
      Layout.topMargin: 8
      Layout.bottomMargin: 8
      Layout.leftMargin: 12
      Layout.rightMargin: 12
      Layout.fillWidth: true
      Layout.preferredHeight: 170
    }

    // ── Divider ──────────────────────────────────────────────────────────
    Rectangle {
      Layout.fillWidth: true
      Layout.leftMargin: 14
      Layout.rightMargin: 14
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // ── Calendar + Weather ───────────────────────────────────────────────
    RowLayout {
      spacing: 10
      Layout.topMargin: 10
      Layout.leftMargin: 12
      Layout.rightMargin: 12
      Layout.bottomMargin: 14
      Layout.fillWidth: true

      Calendar {
        Layout.fillWidth: true
        Layout.preferredHeight: 280
      }

      Weather {
        Layout.preferredWidth: 105
        Layout.preferredHeight: 280
      }
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: quickMenu.visible = false
  }

  MouseArea {
    id: area
    hoverEnabled: true
    anchors.fill: parent
    propagateComposedEvents: true
    onExited: timer.running = true
    onEntered: {
      timer.running = false
      timer.interval = 1000
    }
  }
}
