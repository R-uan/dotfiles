import qs.config
import qs.shared

import QtQuick
import QtQuick.Layouts
import Quickshell

// Quick access to the folders of the base home (Config.homeFolders), whose
// paths can be changed from the settings window.
Item {
  id: root
  implicitHeight: grid.implicitHeight + 20

  // Detached: a Quickshell Process is killed when quickshell exits or reloads
  // its config, and openfilemanager.sh holds kitty in the foreground, so the
  // file manager window went with it. Passing the path as an argument also
  // avoids interpolating it into QML source.
  function openYazi(key) {
    Quickshell.execDetached([Config.scriptsDir + "/openfilemanager.sh", Config.folderPath(key)]);
  }

  // Four equal columns; the folder list is sized to fill whole rows.
  GridLayout {
    id: grid
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 10
    columns: 4
    rowSpacing: 6
    columnSpacing: 6
    uniformCellWidths: true

    Repeater {
      model: Config.homeFolders
      delegate: shortcutPill
    }
  }

  Component {
    id: shortcutPill

    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 32

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
        onClicked: root.openYazi(modelData.key)
      }

      scale: ma.pressed ? 0.96 : 1.0
      Behavior on scale { NumberAnimation { duration: 90; easing.type: Easing.OutCubic } }
    }
  }
}
