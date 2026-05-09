import qs.config
import qs.shared
import qs.windows.taskbar.components

import QtQuick
import QtQuick.Layouts

// Left Section
Item {
  id: root
  height: parent.height
  implicitWidth: layout.implicitWidth

  SharpBackground {
    skewX: -1
    scaleX: 1.06
    anchors.fill: parent
    bottomRightRadius: Theme.radius
  }

  RowLayout {
    id: layout
    anchors.fill: parent
    spacing: Theme.spacing

    Startup {
      Layout.leftMargin: 5
      implicitHeight: parent.height
    }

    SeparatorLine {
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredHeight: parent.height * 0.5
    }
    
    Resources {
      Layout.preferredHeight: parent.height
    }

    SeparatorLine {
      Layout.alignment: Qt.AlignVCenter
      Layout.preferredHeight: parent.height * 0.5
    }

    Playing {
      Layout.preferredHeight: parent.height
    }
  }
}