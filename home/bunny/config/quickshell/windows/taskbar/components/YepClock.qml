import qs.config
import qs.shared

import QtQuick
import Quickshell
import QtQuick.Layouts

Item {
  id: root
  height: parent.height
  implicitWidth: layout.implicitWidth + 20

  SystemClock {
    id: sysclock
    precision: SystemClock.Seconds
  }

  RowLayout {
    id: layout
    height: parent.height
    anchors.centerIn: parent
    spacing: Theme.spacing * 2

    StyledText {
      text: ""
    }

    StyledText {
      font.bold: true
      Layout.alignment: Qt.AlignVCenter
      text: Qt.formatDateTime(sysclock.date, "ddd, dd MMM")
    }

    SeparatorDot {
      Layout.alignment: Qt.AlignVCenter
    }

    StyledText {
      font.bold: true
      Layout.alignment: Qt.AlignVCenter
      text: Qt.formatDateTime(sysclock.date, "HH:mm")
    }
  }
}
