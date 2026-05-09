import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick
import QtQuick.Shapes
import QtQuick.Window
import QtQuick.Layouts

// Middle Section
Item {
  id: root
  height: parent.height
  implicitWidth: layout.implicitWidth + (root.padding * 2)

  readonly property real cutSize: height      // controls steepness of diagonal
  readonly property real padding: height * 1.06 // controls how much space around content

  Canvas {
    anchors.fill: parent

    property real  radius:    Theme.radius
    property color bgColor:   Theme.background
    property real  bgOpacity: Theme.backgroundOpacity

    onWidthChanged:   requestPaint()
    onHeightChanged:  requestPaint()
    onBgColorChanged: requestPaint()

    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)

      var w = width
      var h = height
      var c = root.cutSize
      var r = radius + 8

      ctx.beginPath()
      ctx.moveTo(0, 0)
      ctx.lineTo(w, 0)
      ctx.arcTo(w - c, h, c, h, r)
      ctx.arcTo(c, h, 0, 0, r)
      ctx.closePath()

      ctx.globalAlpha = bgOpacity
      ctx.fillStyle = bgColor
      ctx.fill()
    }
  }

  RowLayout {
    id: layout
    spacing: Theme.spacing
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin:  root.padding
    anchors.rightMargin: root.padding

    Workspaces {}
  }
}