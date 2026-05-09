// SharpBackground.qml

import QtQuick
import qs.config

Rectangle {
  id: root

  property real scaleX:     1.0
  property real skewX:      0.0
  property real translateX: 0.0

  property real skewY:      0.0
  property real scaleY:     1.0
  property real translateY: 0.0

  property real translateZ: 0.0

  property color  bgColor:   Theme.background
  property real   bgOpacity: Theme.backgroundOpacity

  color:   bgColor
  opacity: bgOpacity

  transform: Matrix4x4 {
    matrix: Qt.matrix4x4(
      root.scaleX, root.skewX,  0, root.translateX,
      root.skewY,  root.scaleY, 0, root.translateY,
      0,           0,           1, root.translateZ,
      0,           0,           0, 1
    )
  }
}