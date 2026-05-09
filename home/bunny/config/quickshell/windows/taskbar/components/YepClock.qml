import qs.shared

import QtQuick
import Quickshell
import QtQuick.Layouts

Item {
  id: root
  height: parent.height
  width: clockRow.implicitWidth + 20

  SystemClock {
    id: sysclock
    precision: SystemClock.Seconds
  }

  RowLayout {
    id: clockRow
    spacing: 10
    height: parent.height
    anchors.centerIn: parent

    StyledText {
      text: ""
    }

    StyledText {
      font.bold: true
      Layout.alignment: Qt.AlignVCenter
      text: Qt.formatDateTime(sysclock.date, "ddd, dd MMM")
    }

    StyledText {
      font.bold: true
      Layout.alignment: Qt.AlignVCenter
      text: Qt.formatDateTime(sysclock.date, "HH:mm")
    }
  }
}
