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
  ColumnLayout {
    spacing: 25
    anchors.centerIn: parent


    Item {
      Layout.preferredWidth: root.width
      Layout.preferredHeight: root.height
      Layout.alignment: Qt.AlignHCenter
          clip: true  // clips vertical overflow

      Image {
        id: img
        smooth: true
        mipmap: true
        visible: false
        width: parent.width
        fillMode: Image.PreserveAspectCrop      
        source: WallpaperService.wallpaperPath
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height: sourceSize.height * (parent.width / sourceSize.width)  // scale proportionally
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
          radius: 2
          color: "black"
          width: img.width
          height: img.height
          border.width: 2
          border.color: ThemeDark.border
        }
      }
    }

    //ColumnLayout {
    //  spacing: 2
    //  Layout.preferredWidth: 210

    //  StyledText {
    //    font.pixelSize: Config.fontSize * 1.7
    //    Layout.alignment: Qt.AlignHCenter
    //    font.weight: 400
    //    text: "Ruan"
    //  }

    //  StyledText {
    //    Layout.alignment: Qt.AlignHCenter
    //    font.pixelSize: Config.fontSize + 1
    //    text: "bunny@ruan-nixos"
    //    font.weight: 300
    //  }
    //}
  }
}
