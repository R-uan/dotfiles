import qs.config
import qs.shared

import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
  id: root
  implicitHeight: grid.implicitHeight + 20

  function openYazi(folder) {
    Qt.createQmlObject(`
      import Quickshell.Io
      Process {
        running: true
        command: ["${Config.scriptsDir}/openfilemanager.sh", "${Config.homeShortcutDir}/${folder}"]
      }
    `, root)
  }

  readonly property var dirs: [
    { label: "code",      folder: "code"      },
    { label: "downloads", folder: "downloads" },
    { label: "images",    folder: "images"    },
    { label: "desktop",   folder: "desktop"   },
    { label: "dotfiles",  folder: "dotfiles"  },
    { label: "music",     folder: "music"     },
    { label: "documents", folder: "documents" },
  ]

  // Two fixed rows: first 4, then remaining 3
  ColumnLayout {
    id: grid
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 10
    anchors.topMargin: 10
    spacing: 6

    // Row 1 — 4 items
    RowLayout {
      Layout.fillWidth: true
      spacing: 6
      Repeater {
        model: root.dirs.slice(0, 4)
        delegate: shortcutPill
      }
    }

    // Row 2 — 3 items (left-aligned, same pill width as above)
    RowLayout {
      Layout.fillWidth: true
      spacing: 6
      Repeater {
        model: root.dirs.slice(4)
        delegate: shortcutPill
      }
      // Spacer so pills don't stretch to fill row
      Item { Layout.fillWidth: true }
    }
  }

  Component {
    id: shortcutPill

    Item {
      Layout.preferredHeight: 32
      // Each pill takes an equal share of available width in its row
      Layout.preferredWidth: (root.width - 20 - 18) / 4   // 20=margins, 18=3×spacing

      Rectangle {
        anchors.fill: parent
        radius: 8
        color: ma.containsMouse
          ? (Config.darkMode ? Qt.rgba(1,1,1,0.11) : Qt.rgba(0,0,0,0.09))
          : (Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.04))
        border.color: Config.darkMode ? Qt.rgba(1,1,1,0.09) : Qt.rgba(0,0,0,0.09)
        border.width: 1
        Behavior on color { ColorAnimation { duration: 110 } }
      }

      StyledText {
        text: modelData.label
        font.pixelSize: Config.fontSize - 1
        anchors.centerIn: parent
        color: Config.darkMode
          ? (ma.containsMouse ? ThemeDark.foreground0 : ThemeDark.primary3)
          : (ma.containsMouse ? ThemeLight.foreground0 : ThemeLight.primary3)
        Behavior on color { ColorAnimation { duration: 110 } }
      }

      MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.openYazi(modelData.folder)
      }
    }
  }
}
