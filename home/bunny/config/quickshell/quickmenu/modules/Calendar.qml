// Calendar.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.shared

Item {
  id: root
  SolidBackground {
    anchors.fill: parent
  }

  // — State —
  property var today: new Date()
  property int displayYear: today.getFullYear()
  property int displayMonth: today.getMonth()

  property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August",
    "September", "October", "November", "December"]

  readonly property int cellH: 24
  readonly property int cellW: Math.floor((root.width - 24) / 7)

  function daysInMonth(year, month) {
    return new Date(year, month + 1, 0).getDate();
  }

  function firstDayOfMonth(year, month) {
    return new Date(year, month, 1).getDay();
  }

  function prevMonth() {
    if (displayMonth === 0) {
      displayMonth = 11;
      displayYear -= 1;
    } else {
      displayMonth -= 1;
    }
  }

  Timer {
    interval: 60000  // check every minute
    running: true
    repeat: true
    onTriggered: today = new Date()
  }

  function nextMonth() {
    if (displayMonth === 11) {
      displayMonth = 0;
      displayYear += 1;
    } else {
      displayMonth += 1;
    }
  }

  ColumnLayout {
    spacing: 7
    anchors.centerIn: parent

    // — Header —
    RowLayout {
      Layout.fillWidth: true
      spacing: 0

      Rectangle {
        width: 24
        height: 24
        radius: Theme.radius
        color: prevHover.containsMouse ? Theme.bg3 : "transparent"
        Behavior on color {
          ColorAnimation {
            duration: 120
          }
        }

        Text {
          anchors.centerIn: parent
          text: "‹"
          font.pixelSize: 16
          font.family: Theme.fontFamily
          color: prevHover.containsMouse ? Theme.foreground : Theme.greenBase
          Behavior on color {
            ColorAnimation {
              duration: 120
            }
          }
        }

        MouseArea {
          id: prevHover
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.prevMonth()
        }
      }

      Text {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: root.monthNames[root.displayMonth] + "  " + root.displayYear
        color: Theme.foreground
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.weight: Font.Medium
      }

      Rectangle {
        width: 24
        height: 24
        radius: Theme.radius
        color: nextHover.containsMouse ? Theme.bg3 : "transparent"
        Behavior on color {
          ColorAnimation {
            duration: 120
          }
        }

        Text {
          anchors.centerIn: parent
          text: "›"
          font.pixelSize: 16
          font.family: Theme.fontFamily
          color: nextHover.containsMouse ? Theme.foreground : Theme.greenBase
          Behavior on color {
            ColorAnimation {
              duration: 120
            }
          }
        }

        MouseArea {
          id: nextHover
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.nextMonth()
        }
      }
    }

    // — Day headers —
    Row {
      Layout.fillWidth: true
      Repeater {
        model: ["S", "M", "T", "W", "T", "F", "S"]
        Text {
          width: root.cellW
          height: 18
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          text: modelData
          color: Theme.grey
          font.pixelSize: Theme.fontSize - 3
          font.family: Theme.fontFamily
          font.weight: Font.Medium
        }
      }
    }

    // — Day grid —
    Grid {
      Layout.fillWidth: true
      Layout.fillHeight: true
      columns: 7
      rowSpacing: 2
      columnSpacing: 0

      Repeater {
        model: 42

        delegate: Item {
          id: dayCell

          property int offset: index - root.firstDayOfMonth(root.displayYear, root.displayMonth)
          property int dayNum: offset + 1
          property bool inMonth: dayNum >= 1 && dayNum <= root.daysInMonth(root.displayYear,
                                                                           root.displayMonth)
          property bool isToday: inMonth && dayNum === root.today.getDate() && root.displayMonth
                                 === root.today.getMonth() && root.displayYear === root.today.getFullYear()

          width: root.cellW
          height: root.cellH

          Rectangle {
            anchors.centerIn: parent
            width: parent.width - 4
            height: parent.height - 2
            radius: Theme.radius
            color: dayCell.isToday ? Theme.greenAccent : (cellHover.containsMouse && dayCell.inMonth
                                                          ? Theme.bg3 : "transparent")
            Behavior on color {
              ColorAnimation {
                duration: 100
              }
            }
          }

          Text {
            anchors.centerIn: parent
            text: dayCell.inMonth ? dayCell.dayNum : ""
            font.pixelSize: Theme.fontSize - 2
            font.family: Theme.fontFamily
            color: dayCell.isToday ? Theme.black : dayCell.inMonth ? (cellHover.containsMouse
                                                                      ? Theme.foreground : Theme.greenLight) :
                                                                     "transparent"
            Behavior on color {
              ColorAnimation {
                duration: 100
              }
            }
          }

          MouseArea {
            id: cellHover
            anchors.fill: parent
            hoverEnabled: dayCell.inMonth
            enabled: dayCell.inMonth
          }
        }
      }
    }
  }
}
