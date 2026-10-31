import qs.shared
import qs.config
import qs.services
import QtQuick
import QtQuick.Effects

// Current wallpaper, cropped to fill this item and rounded at its own
// corners. (It used to round the full-height image and get clipped
// afterwards, which cut the bottom corners square.)
Item {
  id: root
  property real radius: 10

  Image {
    id: img
    anchors.fill: parent
    visible: false
    smooth: true
    mipmap: true
    asynchronous: true
    fillMode: Image.PreserveAspectCrop
    sourceSize.width: 960
    source: WallpaperService.wallpaperPath
  }

  MultiEffect {
    anchors.fill: parent
    source: img
    maskEnabled: true
    maskSource: mask
  }

  Item {
    id: mask
    anchors.fill: parent
    layer.enabled: true
    visible: false
    Rectangle {
      anchors.fill: parent
      radius: root.radius
      color: "black"
    }
  }
}
