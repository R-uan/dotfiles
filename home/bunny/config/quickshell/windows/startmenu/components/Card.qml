import qs.shared
import qs.config

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

// Card
Item {
  Background {
    anchors.fill: parent
  }

  ColumnLayout {
    spacing: 25
    anchors.centerIn: parent


    Item {
      Layout.preferredWidth: 150
      Layout.preferredHeight: 150
      Layout.alignment: Qt.AlignHCenter

      Image {
        id: img
        visible: false
        anchors.fill: parent
        source: Config.assetsDir + "/img/cardimg.jpg"
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
          radius: 70
          color: "black"
          width: img.width
          height: img.height
        }
      }
    }

    ColumnLayout {
      spacing: 2
      Layout.preferredWidth: 210

      StyledText {
        font.pixelSize: Theme.fontSize * 1.7
        Layout.alignment: Qt.AlignHCenter
        font.weight: 400
        text: "Ruan"
      }

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        font.pixelSize: Theme.fontSize + 1
        text: "bunny@ruan-nixos"
        font.weight: 300
      }
    }
  }
}
