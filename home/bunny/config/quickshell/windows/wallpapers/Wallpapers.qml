import qs.shared
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
  id: wallpapers
  visible: false
  implicitWidth: 420
  color: "transparent"
  exclusionMode: ExclusionMode.Normal

  anchors {
    top: true
    left: true
    bottom: true
    right: false
  }

  readonly property color colForeground0: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color colPrimary0: Config.darkMode ? ThemeDark.primary0 : ThemeLight.primary0
  readonly property color colPrimary3: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
  readonly property color colBackground1: Config.darkMode ? ThemeDark.background1 : ThemeLight.background1
  readonly property color colBorder: Config.darkMode ? ThemeDark.border : ThemeLight.border
  readonly property color colColour5: Config.darkMode ? ThemeDark.colour5 : ThemeLight.colour4
  readonly property color colColour3: Config.darkMode ? ThemeDark.colour3 : ThemeLight.colour2
  readonly property color colOverlay: Config.darkMode ? "#0a120b" : "#1a2a1c"

  property var wallpaperPaths: []
  property bool isHovered: false

  margins {
    top: 4
    left: 4
    bottom: 4
  }

  Background {
    radius: 12
  }

  // — Fetch wallpaper paths —
  Process {
    id: getWallpapers
    running: true
    command: [Qt.resolvedUrl("./wallpaths.sh")]
    stdout: StdioCollector {
      onStreamFinished: {
        wallpapers.wallpaperPaths = text.trim().split("\n");
      }
    }
  }

  // — Apply wallpaper —
  Process {
    id: applyWallpaper
    running: false
    command: []
  }

  // — Auto-hide timer —
  Timer {
    id: hideTimer
    interval: 1000
    running: false
    onTriggered: wallpapers.visible = false
  }

  // — Main layout —
  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    spacing: 10

    // — Header —
    RowLayout {
      Layout.fillWidth: true

      StyledText {
        text: "Wallpapers"
        color: wallpapers.colForeground0
        font.pixelSize: Config.fontSize + 1
        font.weight: Font.Medium
      }

      Item {
        Layout.fillWidth: true
      }

      StyledText {
        text: wallpapers.wallpaperPaths.length + " found"
        color: wallpapers.colPrimary3
        font.pixelSize: Config.fontSize - 2
      }
    }

    // — Divider —
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: wallpapers.colBorder
      opacity: 0.5
    }

    // — Grid —
    GridView {
      id: wallpapersGrid
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: wallpapers.wallpaperPaths
      cellWidth: Math.floor(width / 3)
      // Portrait aspect ratio ~9:16 to match the tall cards in the image
      cellHeight: Math.floor(cellWidth * 1.78) + 6
      clip: true
      cacheBuffer: 200
      reuseItems: false

      ScrollBar.vertical: ScrollBar {
        id: scrollBar
        policy: ScrollBar.AsNeeded
        interactive: true
        width: 8

        onPressedChanged: {
          if (pressed) {
            hideTimer.running = false;
          } else {
            if (!wallpapers.isHovered)
              hideTimer.running = true;
          }
        }

        contentItem: Rectangle {
          radius: 4
          color: scrollBar.pressed ? wallpapers.colPrimary0 : scrollBar.hovered ? wallpapers.colColour5 :
                                                                                  wallpapers.colColour3
          Behavior on color {
            ColorAnimation {
              duration: 120
            }
          }
        }

        background: Rectangle {
          radius: 4
          color: wallpapers.colBackground1
          opacity: 0.5
        }
      }

      delegate: Item {
        id: delegateRoot
        width: wallpapersGrid.cellWidth
        height: wallpapersGrid.cellHeight

        property string wallPath: modelData

        Item {
          anchors.fill: parent
          // Tighter spacing between cards, matching the image's compact grid
          anchors.margins: 4

          // — Thumbnail —
          Image {
            id: img
            visible: false
            anchors.fill: parent
            source: delegateRoot.wallPath
            asynchronous: true
            sourceSize.width: width
            sourceSize.height: height
            cache: true
            fillMode: Image.PreserveAspectCrop
          }

          MultiEffect {
            source: img
            anchors.fill: img
            maskEnabled: true
            maskSource: mask
          }

          // — Mask with larger radius for prominent rounded corners —
          Item {
            id: mask
            width: img.width
            height: img.height
            layer.enabled: true
            visible: false
            Rectangle {
              anchors.fill: parent
              // Larger radius for the big rounded corners visible in the image
              radius: Config.radius * 2.5
              color: "black"
            }
          }

          // — Hover overlay —
          Rectangle {
            anchors.fill: parent
            radius: Config.radius * 2.5
            color: wallpapers.colOverlay
            opacity: cellHover.containsMouse ? 0.35 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: 150
              }
            }
          }

          // — Hover border —
          Rectangle {
            anchors.fill: parent
            radius: Config.radius * 2.5
            color: "transparent"
            border.color: wallpapers.colPrimary0
            border.width: cellHover.containsMouse ? 2 : 0
            Behavior on border.width {
              NumberAnimation {
                duration: 150
              }
            }
          }

          MouseArea {
            id: cellHover
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
              applyWallpaper.command = ["awww", "img", delegateRoot.wallPath, "--transition-type", "center"];
              applyWallpaper.running = true;
            }
          }
        }
      }
    }
  }

  // — Hover detection for hide logic —
  HoverHandler {
    onHoveredChanged: {
      wallpapers.isHovered = hovered;
      if (hovered) {
        hideTimer.running = false;
      } else if (!scrollBar.pressed) {
        hideTimer.running = true;
      }
    }
  }
}
