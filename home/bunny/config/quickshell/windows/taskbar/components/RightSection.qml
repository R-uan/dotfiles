import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Layouts

// Right Section
Item {
  id: root
  height: parent.height
  implicitWidth: layout.implicitWidth + height

  SharpBackground {
    skewX: 1
    scaleX: 1.06
    anchors.fill: parent
    bottomLeftRadius: Theme.radius
  }

  RowLayout {
    id: layout
    height: parent.height
    spacing: Theme.spacing
    anchors.right: parent.right

    Tray {
      Layout.preferredHeight: parent.height
    }

    SeparatorLine {
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredHeight: parent.height * 0.5
    }

    Network {
      Layout.preferredHeight: parent.height
    }

    SeparatorLine {
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredHeight: parent.height * 0.5
    }

    YepClock {
      Layout.rightMargin: 5
      implicitHeight: parent.height
    }
  }
}