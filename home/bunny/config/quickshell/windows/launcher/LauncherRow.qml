import qs.shared
import qs.config

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
  id: root
  property var entry
  property bool selected: false
  signal activated()

  implicitHeight: 52

  Rectangle {
    anchors.fill: parent
    radius: 10
    color: root.selected
      ? Qt.rgba(1, 1, 1, 0.10)
      : (ma.containsMouse ? Qt.rgba(1, 1, 1, 0.05) : "transparent")
    border.color: root.selected ? Qt.rgba(1, 1, 1, 0.14) : "transparent"
    border.width: 1
    Behavior on color { ColorAnimation { duration: 90 } }
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 10
    anchors.rightMargin: 10
    spacing: 12

    IconImage {
      Layout.preferredWidth: 32
      Layout.preferredHeight: 32
      Layout.alignment: Qt.AlignVCenter
      asynchronous: true
      source: root.entry && root.entry.icon
        ? Quickshell.iconPath(root.entry.icon, "application-x-executable")
        : ""
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: -1

      StyledText {
        Layout.fillWidth: true
        text: root.entry ? root.entry.name : ""
        font.pixelSize: Config.fontSize
        font.weight: Font.Medium
        color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
        elide: Text.ElideRight
      }
      StyledText {
        Layout.fillWidth: true
        visible: root.entry && (root.entry.comment && root.entry.comment.length > 0
                                || root.entry.genericName && root.entry.genericName.length > 0)
        text: {
          if (!root.entry) return "";
          if (root.entry.comment && root.entry.comment.length > 0) return root.entry.comment;
          return root.entry.genericName || "";
        }
        font.pixelSize: Config.fontSize - 4
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        elide: Text.ElideRight
        maximumLineCount: 1
      }
    }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.activated()
  }
}
