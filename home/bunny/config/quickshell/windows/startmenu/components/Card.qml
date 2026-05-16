import qs.shared
import qs.config
import qs.services
import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

// Card
Item {
  id: root
  implicitHeight: col.implicitHeight
  implicitWidth: col.implicitWidth

  ColumnLayout {
    id: col
    spacing: 25
    anchors.centerIn: parent

    Item {
      Layout.preferredWidth: root.width
      // Height follows the image's natural aspect ratio
      Layout.preferredHeight: img.sourceSize.height > 0
        ? img.sourceSize.height * (root.width / img.sourceSize.width)
        : root.width
      Layout.alignment: Qt.AlignHCenter
      clip: true

      Image {
        id: img
        smooth: true
        mipmap: true
        visible: false
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        source: WallpaperService.wallpaperPath
        anchors.centerIn: parent
      }

      MultiEffect {
        source: img
        anchors.fill: img
        maskEnabled: true
        maskSource: mask
      }

      Item {
        id: mask
        width: img.width
        height: img.height
        layer.enabled: true
        visible: false
        Rectangle {
          radius: 8
          color: "black"
          width: img.width
          height: img.height
          border.width: 2
          border.color: ThemeDark.border
        }
      }
    }
  }
}
