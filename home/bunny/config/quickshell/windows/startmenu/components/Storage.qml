import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitHeight: col.implicitHeight + 12

  function fmtSize(bytes) {
    const gib = bytes / (1024 * 1024 * 1024);
    if (gib >= 1000) return (gib / 1024).toFixed(2) + " TiB";
    if (gib >= 10)   return gib.toFixed(0) + " GiB";
    return gib.toFixed(1) + " GiB";
  }

  function barColor(pct) {
    if (pct >= 0.95) return Config.darkMode ? ThemeDark.error   : ThemeLight.error;
    if (pct >= 0.85) return Config.darkMode ? ThemeDark.warning : ThemeLight.warning;
    return Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1;
  }

  ColumnLayout {
    id: col
    spacing: 8
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 6

    // Header
    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      StyledText {
        text: "󰋊"
        font.pixelSize: Config.fontSize
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      StyledText {
        text: "Storage"
        font.pixelSize: Config.fontSize - 2
        font.letterSpacing: 1.4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      Item { Layout.fillWidth: true }
    }

    // Per-disk rows
    Repeater {
      model: StorageService.disks
      delegate: ColumnLayout {
        Layout.fillWidth: true
        spacing: 3

        RowLayout {
          Layout.fillWidth: true
          spacing: 6

          StyledText {
            text: modelData.label
            font.pixelSize: Config.fontSize - 2
            color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
          }

          Item { Layout.fillWidth: true }

          StyledText {
            text: root.fmtSize(modelData.used) + " / " + root.fmtSize(modelData.total)
            font.pixelSize: Config.fontSize - 3
            color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
          }

          StyledText {
            text: Math.round(modelData.percent * 100) + "%"
            font.pixelSize: Config.fontSize - 3
            color: root.barColor(modelData.percent)
            Layout.preferredWidth: 34
            horizontalAlignment: Text.AlignRight
          }
        }

        // Progress bar
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 4
          radius: 2
          color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.08)

          Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.max(2, parent.width * Math.min(1, modelData.percent))
            radius: 2
            color: root.barColor(modelData.percent)
            Behavior on width { NumberAnimation { duration: 250 } }
            Behavior on color { ColorAnimation  { duration: 200 } }
          }
        }
      }
    }
  }
}
