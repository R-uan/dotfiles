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
  property string hoveredPath: ""

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
      reuseItems: true

      ScrollBar.vertical: ScrollBar {
        id: scrollBar
        policy: ScrollBar.AsNeeded
        interactive: true
        width: 8

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
        width: wallpapers.cellWidth
        height: wallpapers.cellHeight

        Item {
          anchors.fill: parent
          anchors.margins: 6

          // — Thumbnail —
          Image {
            id: img
            visible: false
            anchors.fill: parent
            source: modelData
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
            opacity: hoverArea.containsMouse ? 0.35 : 0
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
            border.width: hoverArea.containsMouse ? 2 : 0
            Behavior on border.width {
              NumberAnimation {
                duration: 150
              }
            }
          }

          // — Mouse —
          MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
              applyWallpaper.command = ["swww", "img", modelData, "--transition-type", "center"];
              applyWallpaper.running = true;
            }
          }
        }
      }
    }
  }

  // — Auto-hide timer —
  Timer {
    id: hideTimer
    interval: 1000
    running: false
    onTriggered: wallpicker.visible = false
  }

  MouseArea {
    id: area
    anchors.fill: parent
    anchors.rightMargin: 24
    hoverEnabled: true
    propagateComposedEvents: true
    onExited: {
      if (!scrollBar.pressed)
        hideTimer.running = true;
    }
    onEntered: {
      hideTimer.running = false;
      hideTimer.interval = 1000;
    }
  }

  Connections {
    target: scrollBar
    function onPressedChanged() {
      if (!scrollBar.pressed) {
        if (!area.containsMouse)
          hideTimer.running = true;
      } else {
        hideTimer.running = false;
      }
    }
  }
}
