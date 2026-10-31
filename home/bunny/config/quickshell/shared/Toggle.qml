import qs.config

import QtQuick

// Small on/off switch. Emits toggled(); the owner flips `checked` from its
// real state, so a failed action doesn't leave the switch lying.
Item {
  id: root
  property bool checked: false
  signal toggled()

  implicitWidth: 30
  implicitHeight: 16

  Rectangle {
    anchors.fill: parent
    radius: height / 2
    color: root.checked
      ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
      : (Config.darkMode ? Qt.rgba(1,1,1, ma.containsMouse ? 0.14 : 0.08) : Qt.rgba(0,0,0, ma.containsMouse ? 0.14 : 0.08))
    Behavior on color { CAnim {} }
  }

  Rectangle {
    width: parent.height - 4
    height: width
    radius: width / 2
    y: 2
    x: root.checked ? root.width - width - 2 : 2
    color: root.checked
      ? (Config.darkMode ? ThemeDark.background0 : ThemeLight.background0)
      : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)
    Behavior on x { Anim { duration: Motion.fastSpatialDuration } }
    Behavior on color { CAnim {} }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.toggled()
  }
}
