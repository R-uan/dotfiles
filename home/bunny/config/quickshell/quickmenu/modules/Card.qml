import qs.shared

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Window
import QtQuick.Layouts

// Card
Item {
  SolidBackground {
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
        source: "cardimg.jpg"
      }

      MultiEffect {
        source: img
        anchors.fill: img
        maskEnabled: true
        maskSource: mask
      }

      // Rectangle {
      //   radius: 100
      //   border.width: 1
      //   anchors.fill: parent
      //   color: "transparent"
      //   border.color: Theme.primary
      // }

      Item {
        id: mask
        width: img.width
        height: img.height
        layer.enabled: true
        visible: false

        Rectangle {
          radius: 100
          color: "black"
          width: img.width
          height: img.height
        }
      }
    }

    ColumnLayout {
      spacing: 5
      Layout.preferredWidth: 210

      CommonText {
        font.pixelSize: Theme.fontSize + 17
        Layout.alignment: Qt.AlignHCenter
        font.weight: 400
        text: "Ruan"
      }

      CommonText {
        Layout.alignment: Qt.AlignHCenter
        font.pixelSize: Theme.fontSize + 1
        text: "@forgetfullbnnuy"
        font.weight: 300
      }
    }
  }
}
