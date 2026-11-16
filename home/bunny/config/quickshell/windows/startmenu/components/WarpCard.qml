import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

// Cloudflare WARP card: a bigger, friendlier version of what used to be
// a cramped NetPill — icon tile, status line, and a toggle pill.
Item {
  id: root
  implicitHeight: 62

  readonly property bool _on: WarpService.connected
  readonly property bool _busy: WarpService.transitioning || WarpService.busy
  readonly property color _accent: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
  readonly property color _success: Config.darkMode ? ThemeDark.success : ThemeLight.success
  readonly property color _muted:  Config.darkMode ? ThemeDark.muted    : ThemeLight.muted
  readonly property color _fg:     Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _dim:    Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: root._on
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.05))
      : (Config.darkMode ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03))
    border.color: root._on
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.12) : Qt.rgba(0,0,0,0.10))
      : (Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06))
    border.width: 1
    Behavior on color       { ColorAnimation { duration: 180 } }
    Behavior on border.color{ ColorAnimation { duration: 180 } }
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 12
    anchors.rightMargin: 10
    spacing: 12

    // ── Icon tile ──────────────────────────────────────────────
    Rectangle {
      Layout.preferredWidth: 38
      Layout.preferredHeight: 38
      radius: 10
      color: root._on
        ? Qt.rgba(root._accent.r, root._accent.g, root._accent.b, 0.18)
        : (Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.05))
      border.color: root._on
        ? Qt.rgba(root._accent.r, root._accent.g, root._accent.b, 0.35)
        : (Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.08))
      border.width: 1
      Behavior on color       { ColorAnimation { duration: 180 } }
      Behavior on border.color{ ColorAnimation { duration: 180 } }

      StyledText {
        anchors.centerIn: parent
        text: WarpService.icon
        font.pixelSize: 19
        color: root._on ? root._accent : root._muted
        Behavior on color { ColorAnimation { duration: 180 } }

        // Subtle pulse while the daemon is flipping states.
        SequentialAnimation on opacity {
          running: root._busy
          loops: Animation.Infinite
          NumberAnimation { to: 0.45; duration: 500; easing.type: Easing.InOutQuad }
          NumberAnimation { to: 1.0;  duration: 500; easing.type: Easing.InOutQuad }
        }
      }
    }

    // ── Label + status ─────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2

      RowLayout {
        Layout.fillWidth: true
        spacing: 6
        StyledText {
          text: "WARP"
          font.pixelSize: Config.fontSize - 1
          font.weight: Font.Medium
          font.letterSpacing: 1.6
          color: root._fg
        }
        StyledText {
          text: "·  cloudflare"
          font.pixelSize: Config.fontSize - 5
          font.letterSpacing: 1.2
          color: root._dim
        }
        Item { Layout.fillWidth: true }
      }

      StyledText {
        text: WarpService.statusText.toLowerCase()
        font.pixelSize: Config.fontSize - 3
        color: root._on ? root._success : (root._busy ? root._accent : root._muted)
        Behavior on color { ColorAnimation { duration: 180 } }
      }
    }

    // ── Toggle switch ──────────────────────────────────────────
    Rectangle {
      id: sw
      Layout.preferredWidth: 46
      Layout.preferredHeight: 24
      radius: 12
      color: root._on
        ? Qt.rgba(root._accent.r, root._accent.g, root._accent.b, 0.75)
        : (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.12))
      opacity: root._busy ? 0.6 : (ma.containsMouse ? 1 : 0.95)
      Behavior on color  { ColorAnimation { duration: 200 } }
      Behavior on opacity{ NumberAnimation { duration: 140 } }

      Rectangle {
        id: knob
        width: 18
        height: 18
        radius: 9
        y: 3
        x: root._on ? parent.width - width - 3 : 3
        color: Config.darkMode ? ThemeDark.foreground0 : "#ffffff"
        Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
      }

      MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: WarpService.toggle()
      }
    }
  }

  // Clicking the whole card (except the switch area) also toggles, so the
  // card feels like one target.
  MouseArea {
    anchors.fill: parent
    anchors.rightMargin: 60   // leave the switch its own click area
    cursorShape: Qt.PointingHandCursor
    onClicked: WarpService.toggle()
    z: -1
  }
}
