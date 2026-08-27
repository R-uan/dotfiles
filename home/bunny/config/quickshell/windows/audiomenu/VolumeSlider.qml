import qs.config

import QtQuick

// Minimal click/drag/scroll slider. The project doesn't pull in
// QtQuick.Controls styling anywhere else, so this stays hand-rolled.
Item {
  id: root
  property int value: 0          // 0-100
  property bool dimmed: false    // drawn muted when the target is muted
  signal moved(int value)

  implicitHeight: 16

  readonly property real _frac: Math.max(0, Math.min(1, value / 100))
  readonly property color _fill: root.dimmed
    ? (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
    : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)

  Rectangle {
    id: track
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    height: 5
    radius: 2.5
    color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.08)

    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: Math.max(parent.height, parent.width * root._frac)
      radius: parent.radius
      color: root._fill
      Behavior on color { ColorAnimation { duration: 140 } }
    }
  }

  Rectangle {
    id: knob
    width: 12
    height: 12
    radius: 6
    // Centre tracks the same 0..width mapping the click maths uses, so the
    // knob always lands under the cursor.
    x: Math.max(0, Math.min(track.width - width, track.width * root._frac - width / 2))
    anchors.verticalCenter: parent.verticalCenter
    color: root._fill
    border.color: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
    border.width: 2
    scale: ma.containsMouse || ma.pressed ? 1.15 : 1
    Behavior on scale { NumberAnimation { duration: 110 } }
    Behavior on color { ColorAnimation { duration: 140 } }
  }

  function _emitAt(mx) {
    if (track.width <= 0) return;
    root.moved(Math.round(Math.max(0, Math.min(1, mx / track.width)) * 100));
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    preventStealing: true

    onPressed: function (mouse) { root._emitAt(mouse.x); }
    onPositionChanged: function (mouse) { if (pressed) root._emitAt(mouse.x); }
    onWheel: function (wheel) {
      const step = wheel.angleDelta.y > 0 ? 5 : -5;
      root.moved(Math.max(0, Math.min(100, root.value + step)));
    }
  }
}
