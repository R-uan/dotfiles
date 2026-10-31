import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick.Effects

// Focused window, read top to bottom along the bar: a grayscale app icon
// followed by the rotated title. Fills whatever space the parent gives it
// and elides the title to fit.
Item {
  id: root

  // What's displayed lags the real focus by a fade-out, so switching
  // windows cross-fades instead of the icon and title snapping (caelestia).
  // Title changes within the same window still update live.
  readonly property var _focused: ToplevelManager.activeToplevel
  property var toplevel: null
  readonly property string title: toplevel?.title ?? ""
  readonly property string appId: toplevel?.appId ?? ""
  readonly property string iconSource: AppIcons.source(appId)

  on_FocusedChanged: swap.restart()
  Component.onCompleted: toplevel = _focused

  SequentialAnimation {
    id: swap
    Anim { target: root; property: "opacity"; to: 0; curve: Motion.accel; duration: 120 }
    ScriptAction { script: root.toplevel = root._focused }
    Anim { target: root; property: "opacity"; to: 1; curve: Motion.effects; duration: Motion.effectsDuration }
  }

  // The bar is too narrow for anything useful once it shrinks below this.
  visible: toplevel !== null && height > 70

  Item {
    id: iconBox
    anchors.top: parent.top
    anchors.topMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    width: 18
    height: 18

    IconImage {
      id: appIcon
      anchors.fill: parent
      asynchronous: true
      source: root.iconSource
      visible: false
    }

    // Desaturated, so colourful app icons don't break the monochrome bar.
    MultiEffect {
      anchors.fill: parent
      source: appIcon
      saturation: -1
      opacity: 0.85
      visible: root.iconSource.length > 0
    }

    StyledText {
      anchors.centerIn: parent
      visible: root.iconSource.length === 0
      text: "󰖯"
      font.pixelSize: 14
      color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
    }
  }

  Rectangle {
    id: rule
    anchors.top: iconBox.bottom
    anchors.topMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    width: 10
    height: 1
    color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.15)
  }

  Item {
    id: titleBox
    anchors.top: rule.bottom
    anchors.topMargin: 6
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 6
    anchors.left: parent.left
    anchors.right: parent.right
    clip: true

    StyledText {
      // Laid out horizontally at the box's height, then turned to run down
      // the bar. Anchored to the top so short titles hug the icon.
      width: titleBox.height
      x: (titleBox.width - width) / 2
      y: (width - height) / 2
      rotation: 90
      text: root.title
      elide: Text.ElideRight
      maximumLineCount: 1
      font.pixelSize: Config.fontSize - 2
      font.letterSpacing: 0.6
      color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
    }
  }
}
