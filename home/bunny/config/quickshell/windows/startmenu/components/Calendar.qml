import qs.config
import qs.shared

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
  id: root

  // — Theme aliases —
  readonly property color colBackground1: Config.darkMode ? ThemeDark.background1  : ThemeLight.background1
  readonly property color colForeground0: Config.darkMode ? ThemeDark.foreground0  : ThemeLight.foreground0
  readonly property color colPrimary3:    Config.darkMode ? ThemeDark.primary3     : ThemeLight.primary3
  readonly property color colPrimary0:    Config.darkMode ? ThemeDark.primary0     : ThemeLight.primary0
  readonly property color colColour6:     Config.darkMode ? ThemeDark.colour6      : ThemeLight.colour5
  readonly property color colText:        Config.darkMode ? ThemeDark.background0  : ThemeLight.background0

  // — State —
  property var today: new Date()
  property int displayYear: today.getFullYear()
  property int displayMonth: today.getMonth()

  property var monthNames: ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"]

  readonly property int cellH: 24
  readonly property int cellW: Math.floor((root.width - 24) / 7)

  function daysInMonth(year, month) { return new Date(year, month + 1, 0).getDate() }
  function firstDayOfMonth(year, month) { return new Date(year, month, 1).getDay() }

  function prevMonth() {
    if (displayMonth === 0) { displayMonth = 11; displayYear -= 1 }
    else { displayMonth -= 1 }
  }

  function nextMonth() {
    if (displayMonth === 11) { displayMonth = 0; displayYear += 1 }
    else { displayMonth += 1 }
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: today = new Date()
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
        radius: Config.radius
        color: prevHover.containsMouse ? root.colBackground1 : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }

        StyledText {
          anchors.centerIn: parent
          text: "‹"
          font.pixelSize: 16
          color: prevHover.containsMouse ? root.colForeground0 : root.colPrimary0
          Behavior on color { ColorAnimation { duration: 120 } }
        }

        MouseArea {
          id: prevHover
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.prevMonth()
        }
      }

      StyledText {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: root.monthNames[root.displayMonth] + "  " + root.displayYear
        color: root.colForeground0
        font.pixelSize: Config.fontSize
        font.weight: Font.Medium
      }

      Rectangle {
        width: 24
        height: 24
        radius: Config.radius
        color: nextHover.containsMouse ? root.colBackground1 : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }

        StyledText {
          anchors.centerIn: parent
          text: "›"
          font.pixelSize: 16
          color: nextHover.containsMouse ? root.colForeground0 : root.colPrimary0
          Behavior on color { ColorAnimation { duration: 120 } }
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
        StyledText {
          width: root.cellW
          height: 18
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          text: modelData
          color: root.colPrimary3
          font.pixelSize: Config.fontSize - 3
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
          property bool inMonth: dayNum >= 1 && dayNum <= root.daysInMonth(root.displayYear, root.displayMonth)
          property bool isToday: inMonth && dayNum === root.today.getDate()
                                 && root.displayMonth === root.today.getMonth()
                                 && root.displayYear === root.today.getFullYear()

          width: root.cellW
          height: root.cellH

          Rectangle {
            anchors.centerIn: parent
            width: parent.width - 4
            height: parent.height - 2
            radius: Config.radius
            color: dayCell.isToday
              ? root.colPrimary0
              : (cellHover.containsMouse && dayCell.inMonth ? root.colBackground1 : "transparent")
            Behavior on color { ColorAnimation { duration: 100 } }
          }

          StyledText {
            anchors.centerIn: parent
            text: dayCell.inMonth ? dayCell.dayNum : ""
            font.pixelSize: Config.fontSize - 2
            color: dayCell.isToday
              ? root.colText
              : dayCell.inMonth
                ? (cellHover.containsMouse ? root.colForeground0 : root.colPrimary3)
                : "transparent"
            Behavior on color { ColorAnimation { duration: 100 } }
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
