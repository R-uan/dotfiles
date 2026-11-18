import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

// Capture surface: screenshots on one line, screen recording on the next,
// each with a small label at the left so a glance is enough. The clipboard
// shortcut rides along at the end of the shoot row — it reads naturally as
// "shots land in the clipboard, and here's the clipboard".
Item {
  id: root
  implicitHeight: col.implicitHeight

  // Give the start menu time to close so it isn't in the shot.
  function shoot(mode) {
    startmenu.shown = false;
    Quickshell.execDetached(["sh", "-c",
      "sleep 0.35; hyprshot " + (mode === "region" ? "--freeze -m region" : "-m window") + " --clipboard-only"]);
  }

  function record(mode) {
    startmenu.shown = false;
    RecorderService.toggle(mode);
  }

  readonly property color _label:  Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _fg:     Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _accent: Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1

  component SectionLabel: StyledText {
    Layout.preferredWidth: 46
    Layout.alignment: Qt.AlignVCenter
    font.pixelSize: Config.fontSize - 5
    font.letterSpacing: 1.3
    color: root._label
  }

  component Tile: Item {
    id: tile
    property string label
    property string icon
    property bool active: false
    property bool emphasised: false
    signal activated()

    Layout.fillWidth: true
    Layout.preferredHeight: 38

    scale: ma.pressed ? 0.95 : 1.0
    Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }

    Rectangle {
      anchors.fill: parent
      radius: 10
      color: tile.active || tile.emphasised
        ? (Config.darkMode ? Qt.rgba(1,1,1, ma.containsMouse ? 0.17 : 0.12) : Qt.rgba(0,0,0, ma.containsMouse ? 0.15 : 0.10))
        : (Config.darkMode ? Qt.rgba(1,1,1, ma.containsMouse ? 0.08 : 0.03) : Qt.rgba(0,0,0, ma.containsMouse ? 0.07 : 0.03))
      border.width: 1
      border.color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
      Behavior on color { CAnim {} }
    }

    RowLayout {
      anchors.centerIn: parent
      spacing: 5

      StyledText {
        text: tile.icon
        font.pixelSize: 14
        color: ma.containsMouse || tile.active || tile.emphasised ? root._fg : root._accent
      }
      StyledText {
        text: tile.label
        font.pixelSize: Config.fontSize - 5
        color: root._accent
        visible: tile.width > 60
      }
    }

    MouseArea {
      id: ma
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: tile.activated()
    }
  }

  ColumnLayout {
    id: col
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 6

    // ── Screenshot ────────────────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      SectionLabel { text: "SHOOT" }
      Tile { label: "Region";    icon: "󰆞"; onActivated: root.shoot("region") }
      Tile { label: "Window";    icon: "󰖯"; onActivated: root.shoot("window") }
      Tile { label: "Clipboard"; icon: "󰅌"; onActivated: clipboard.shown = true }
    }

    // ── Record ────────────────────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      SectionLabel { text: "RECORD" }

      // While recording, the start tiles collapse into one wide Stop tile so
      // the only useful action is the obvious one.
      Tile {
        visible: !RecorderService.recording
        label: "Region"
        icon: "󰆞"
        onActivated: root.record("region")
      }
      Tile {
        visible: !RecorderService.recording
        label: "Screen"
        icon: "󰍹"
        onActivated: root.record("screen")
      }
      Tile {
        visible: RecorderService.recording
        label: "Stop recording"
        icon: "󰓛"
        emphasised: true
        onActivated: root.record("region")
      }

      // Audio toggle stays reachable mid-recording so you can mute on the fly.
      Tile {
        Layout.maximumWidth: 72
        label: RecorderService.withAudio ? "Audio" : "Muted"
        icon:  RecorderService.withAudio ? "󰕾" : "󰖁"
        active: RecorderService.withAudio
        onActivated: RecorderService.withAudio = !RecorderService.withAudio
      }
    }
  }
}
