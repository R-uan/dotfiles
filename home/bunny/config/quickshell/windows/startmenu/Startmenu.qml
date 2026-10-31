import qs.shared
import qs.config
import qs.services
import qs.windows.startmenu.components
import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

DockedPanel {
  edge: "top"
  id: quickMenu
  visible: false
  cardWidth: 480
  color: "transparent"
  objectName: "Start Menu"
  cardHeight: mainLayout.implicitHeight
  exclusionMode: ExclusionMode.Normal

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

      Item {
        id: cardClip
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: 155

        Card {
          id: cardInner
          anchors.fill: parent
        }

        // Greeting over the wallpaper (caelestia's user/date card).
        Rectangle {
          anchors.fill: parent
          radius: cardInner.radius
          gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.55) }
            GradientStop { position: 0.6; color: Qt.rgba(0, 0, 0, 0.0) }
          }
        }

        SystemClock {
          id: heroClock
          precision: SystemClock.Minutes
        }

        ColumnLayout {
          anchors.left: parent.left
          anchors.bottom: parent.bottom
          anchors.leftMargin: 14
          anchors.bottomMargin: 12
          spacing: 0

          StyledText {
            text: Qt.formatTime(heroClock.date, "HH:mm")
            font.pixelSize: Config.fontSize + 22
            font.weight: Font.Medium
            color: Qt.rgba(1, 1, 1, 0.95)
          }
          StyledText {
            readonly property int _h: heroClock.date.getHours()
            text: (_h < 5 ? "Good night" : _h < 12 ? "Good morning" : _h < 18 ? "Good afternoon" : "Good evening")
                  + ", " + (Quickshell.env("USER") || "you")
            font.pixelSize: Config.fontSize - 1
            color: Qt.rgba(1, 1, 1, 0.85)
          }
          StyledText {
            text: "up " + UptimeService.uptimeShort
            font.pixelSize: Config.fontSize - 4
            font.letterSpacing: 1.2
            color: Qt.rgba(1, 1, 1, 0.55)
          }
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

    // ── Quick toggles ────────────────────────────────────────────────────
    QuickToggles {
      Layout.topMargin: 4
      Layout.leftMargin: 14
      Layout.rightMargin: 14
      Layout.fillWidth: true
    }

    // ── Capture: screenshots, recording, clipboard ───────────────────────
    CaptureRow {
      Layout.topMargin: 6
      Layout.leftMargin: 14
      Layout.rightMargin: 14
      Layout.fillWidth: true
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

    // ── Storage ──────────────────────────────────────────────────────────
    Storage {
      Layout.topMargin: 8
      Layout.leftMargin: 14
      Layout.rightMargin: 14
      Layout.fillWidth: true
    }

    // ── Divider ──────────────────────────────────────────────────────────
    Rectangle {
      Layout.fillWidth: true
      Layout.leftMargin: 14
      Layout.rightMargin: 14
      Layout.topMargin: 8
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

    // ── App shortcuts ────────────────────────────────────────────────────
    AppLauncher {
      Layout.topMargin: 6
      Layout.bottomMargin: 12
      Layout.leftMargin: 12
      Layout.rightMargin: 12
      Layout.fillWidth: true
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
