import QtQuick
import QtQuick.Layouts
import qs.shared

Item {
  id: root
  Layout.fillHeight: true
  Layout.preferredWidth: 45

  ColumnLayout {
    anchors.fill: parent
    Layout.preferredWidth: parent.width
    Repeater {
      model: [
        {
          icon: "",
          path: ""
        },
        {
          icon: "󰈙",
          path: ""
        },
        {
          icon: "󰇚",
          path: ""
        },
        {
          icon: "",
          path: ""
        },
        {
          icon: "",
          path: ""
        },
        {
          icon: "󱁻",
          path: ""
        },
      ]

      delegate: Item {
        width: 45
        height: 45

        SolidBackground {
          anchors.fill: parent
        }

        CommonText {
          font.pixelSize: 25
          text: modelData.icon
          anchors.centerIn: parent
        }

        MouseArea {
          anchors.fill: parent
        }
      }
    }
  }
}
