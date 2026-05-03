// Wallpicker.qml
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import qs.shared

PanelWindow {
  id: wallpicker
  visible: false
  implicitWidth: 860
  implicitHeight: 620
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  margins {
    bottom: 10
    left: Theme.margins + 15
    top: Theme.barHeight + Theme.margins + 2
  }

  property var wallpaperPaths: []
  property bool isHovered: false

  // — Background —
  SolidBackground {
    anchors.fill: parent
  }

  // — Fetch wallpaper paths —
  Process {
    id: getWallpapers
    running: true
    command: [Qt.resolvedUrl("./wallpaths.sh")]
    stdout: StdioCollector {
      onStreamFinished: {
        wallpicker.wallpaperPaths = text.trim().split("\n");
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
    onTriggered: wallpicker.visible = false
  }

  // — Main layout —
  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 16
    spacing: 12

    // — Header —
    RowLayout {
      Layout.fillWidth: true

      Text {
        text: "Wallpapers"
        color: Theme.foreground
        font.pixelSize: Theme.fontSize + 1
        font.family: Theme.fontFamily
        font.weight: Font.Medium
      }

      Item {
        Layout.fillWidth: true
      }

      Text {
        text: wallpicker.wallpaperPaths.length + " found"
        color: Theme.grey
        font.pixelSize: Theme.fontSize - 2
        font.family: Theme.fontFamily
      }
    }

    // — Divider —
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Theme.borderColour
      opacity: 0.5
    }

    // — Grid —
    GridView {
      id: wallpapers
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: wallpicker.wallpaperPaths
      cellWidth: Math.floor(width / 3)
      cellHeight: Math.floor(cellWidth * 0.5625) + 6
      clip: true
      cacheBuffer: 200
      reuseItems: false  // prevents delegate reuse bugs with MultiEffect

      ScrollBar.vertical: ScrollBar {
        id: scrollBar
        policy: ScrollBar.AsNeeded
        interactive: true
        width: 8

        onPressedChanged: {
          if (pressed) {
            hideTimer.running = false;
          } else {
            if (!wallpicker.isHovered)
              hideTimer.running = true;
          }
        }

        contentItem: Rectangle {
          radius: 4
          color: scrollBar.pressed ? Theme.greenAccent : scrollBar.hovered ? Theme.greenLight : Theme.greenMid
          Behavior on color {
            ColorAnimation {
              duration: 120
            }
          }
        }

        background: Rectangle {
          radius: 4
          color: Theme.bg3
          opacity: 0.5
        }
      }

      delegate: Item {
        id: delegateRoot
        width: wallpapers.cellWidth
        height: wallpapers.cellHeight

        // capture modelData before it goes out of scope
        property string wallPath: modelData

        Item {
          anchors.fill: parent
          anchors.margins: 6

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

          // — Mask —
          Item {
            id: mask
            width: img.width
            height: img.height
            layer.enabled: true
            visible: false
            Rectangle {
              anchors.fill: parent
              radius: Theme.radius
              color: "black"
            }
          }

          // — Hover overlay —
          Rectangle {
            anchors.fill: parent
            radius: Theme.radius
            color: Theme.black
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
            radius: Theme.radius
            color: "transparent"
            border.color: Theme.greenAccent
            border.width: cellHover.containsMouse ? 2 : 0
            Behavior on border.width {
              NumberAnimation {
                duration: 150
              }
            }
          }

          // — Click + hover —
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
      wallpicker.isHovered = hovered;
      if (hovered) {
        hideTimer.running = false;
      } else if (!scrollBar.pressed) {
        hideTimer.running = true;
      }
    }
  }
}
