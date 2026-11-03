import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell

// What each monitor shows while locked: the wallpaper blurred and dimmed,
// a big clock, weather, the password pill and what's playing.
// Type the password and press Enter · Esc clears it.
Item {
  id: root
  required property var ctx

  readonly property color _fg:  Qt.rgba(1, 1, 1, 0.95)
  readonly property color _sub: Qt.rgba(1, 1, 1, 0.62)
  readonly property color _dim: Qt.rgba(1, 1, 1, 0.38)
  readonly property bool _busy: ctx.status === "checking"
  readonly property bool _bad: ctx.status === "failed" || ctx.status === "error"

  // Fade/slide in when the surface appears.
  property real _in: 0
  Component.onCompleted: { introAnim.start(); input.forceActiveFocus(); }
  NumberAnimation on _in {
    id: introAnim
    running: false
    from: 0; to: 1
    duration: Motion.spatialDuration
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Motion.decel
  }

  Connections {
    target: root.ctx
    function onFailed() {
      input.text = "";
      shake.restart();
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  // ── Background ──────────────────────────────────────────────────────
  Image {
    id: wall
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: WallpaperService.wallpaperPath
    sourceSize.width: 1280
    asynchronous: true
    visible: false
  }
  MultiEffect {
    anchors.fill: parent
    source: wall
    blurEnabled: true
    blur: 1.0
    blurMax: 64
    saturation: -0.3
    opacity: wall.status === Image.Ready ? 1 : 0
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration * 2 } }
  }
  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.35) }
      GradientStop { position: 0.6; color: Qt.rgba(0, 0, 0, 0.50) }
      GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.70) }
    }
  }

  // Clicking anywhere gives the field its focus back.
  MouseArea {
    anchors.fill: parent
    onClicked: input.forceActiveFocus()
  }

  // ── Clock, date, weather ────────────────────────────────────────────
  ColumnLayout {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: authBox.top
    anchors.bottomMargin: 56
    spacing: 4
    opacity: root._in
    transform: Translate { y: (1 - root._in) * -24 }

    StyledText {
      Layout.alignment: Qt.AlignHCenter
      text: Qt.formatTime(clock.date, "HH:mm")
      font.pixelSize: 132
      font.weight: Font.Light
      color: root._fg
    }
    StyledText {
      Layout.alignment: Qt.AlignHCenter
      readonly property string _d: Qt.locale(Config.timeLocale).toString(clock.date, "dddd, d MMMM")
      text: _d.charAt(0).toUpperCase() + _d.slice(1)
      font.pixelSize: Config.fontSize + 4
      color: root._sub
    }
    StyledText {
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: 6
      visible: Config.weatherEnabled && WeatherService.ready
      text: WeatherService.icon + "  " + WeatherService.temp + "°  ·  " + WeatherService.description
      font.pixelSize: Config.fontSize
      color: root._dim
    }
  }

  // ── Password ────────────────────────────────────────────────────────
  ColumnLayout {
    id: authBox
    anchors.centerIn: parent
    anchors.verticalCenterOffset: 60
    spacing: 14
    opacity: root._in

    // Avatar: the user's initial in a ring.
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 64
      height: 64
      radius: 32
      color: Qt.rgba(1, 1, 1, 0.08)
      border.width: 1
      border.color: Qt.rgba(1, 1, 1, 0.16)
      StyledText {
        anchors.centerIn: parent
        text: (Quickshell.env("USER") || "?").charAt(0).toUpperCase()
        font.pixelSize: 28
        color: root._fg
      }
    }
    StyledText {
      Layout.alignment: Qt.AlignHCenter
      text: Quickshell.env("USER") || ""
      font.pixelSize: Config.fontSize
      font.letterSpacing: 1.2
      color: root._sub
    }

    Rectangle {
      id: pill
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: 4
      implicitWidth: 300
      implicitHeight: 46
      radius: 23
      color: Qt.rgba(1, 1, 1, input.activeFocus ? 0.10 : 0.07)
      border.width: 1
      border.color: root._bad ? Qt.rgba(1, 1, 1, 0.45)
                  : input.activeFocus ? Qt.rgba(1, 1, 1, 0.22) : Qt.rgba(1, 1, 1, 0.12)
      Behavior on border.color { CAnim {} }

      transform: Translate { id: shakeT }
      SequentialAnimation {
        id: shake
        loops: 1
        NumberAnimation { target: shakeT; property: "x"; to: -10; duration: 50 }
        NumberAnimation { target: shakeT; property: "x"; to: 10;  duration: 70 }
        NumberAnimation { target: shakeT; property: "x"; to: -6;  duration: 70 }
        NumberAnimation { target: shakeT; property: "x"; to: 0;   duration: 60 }
      }

      // The real field is invisible; the dots below stand in for it.
      TextInput {
        id: input
        anchors.fill: parent
        opacity: 0
        focus: true
        enabled: !root._busy
        echoMode: TextInput.Password
        onAccepted: root.ctx.tryUnlock(text)
        Keys.onEscapePressed: text = ""
        onTextChanged: if (text.length > 0 && root._bad) { root.ctx.status = ""; root.ctx.message = ""; }
      }

      StyledText {
        anchors.centerIn: parent
        visible: input.text.length === 0 && !root._busy
        text: root._bad ? root.ctx.message : "Enter password"
        font.pixelSize: Config.fontSize - 2
        color: root._bad ? root._sub : root._dim
      }

      Row {
        anchors.centerIn: parent
        spacing: 6
        Repeater {
          model: Math.min(input.text.length, 24)
          delegate: Rectangle {
            width: 8
            height: 8
            radius: 4
            color: root._fg
            opacity: root._busy ? 0.4 : 1
            scale: 0
            Component.onCompleted: scale = 1
            Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }
          }
        }
      }

      // Lock glyph; spins while PAM is checking.
      StyledText {
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        text: root._busy ? "󰑐" : "󰌾"
        font.pixelSize: Config.fontSize + 1
        color: root._dim
        RotationAnimation on rotation {
          running: root._busy
          from: 0; to: 360
          duration: 900
          loops: Animation.Infinite
          onStopped: parent.rotation = 0
        }
      }
    }
  }

  // ── Now playing ─────────────────────────────────────────────────────
  Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 48
    visible: MediaService.hasPlayer
    opacity: root._in
    implicitWidth: mediaRow.implicitWidth + 28
    implicitHeight: 44
    radius: 22
    color: Qt.rgba(1, 1, 1, 0.07)
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.10)

    RowLayout {
      id: mediaRow
      anchors.centerIn: parent
      spacing: 10

      StyledText {
        text: "󰝚"
        font.pixelSize: Config.fontSize
        color: root._dim
      }
      StyledText {
        Layout.maximumWidth: 360
        text: (MediaService.player?.trackTitle || "Unknown track")
              + (MediaService.player?.trackArtist ? "  ·  " + MediaService.player.trackArtist : "")
        font.pixelSize: Config.fontSize - 2
        color: root._sub
        elide: Text.ElideRight
      }
      Repeater {
        model: [
          { icon: "󰒮", run: () => MediaService.previous(), on: MediaService.player?.canGoPrevious ?? false },
          { icon: MediaService.player?.isPlaying ? "󰏤" : "󰐊", run: () => MediaService.togglePlaying(), on: true },
          { icon: "󰒭", run: () => MediaService.next(), on: MediaService.player?.canGoNext ?? false }
        ]
        delegate: StyledText {
          required property var modelData
          text: modelData.icon
          font.pixelSize: Config.fontSize + 2
          color: mediaMouse.containsMouse ? root._fg : root._sub
          opacity: modelData.on ? 1 : 0.35
          MouseArea {
            id: mediaMouse
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: true
            enabled: parent.modelData.on
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.modelData.run()
          }
        }
      }
    }
  }
}
