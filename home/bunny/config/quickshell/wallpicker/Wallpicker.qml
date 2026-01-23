import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import qs.shared

PanelWindow {
  id: wallpicker
  visible: false
  implicitWidth: 800
  implicitHeight: 600
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  property var wallpaperPaths

  margins {
    bottom: 10
    left: Theme.margins + 15
    top: Theme.barHeight + Theme.margins + 2
  }

  SolidBackground {
    anchors.fill: parent
  }

  Process {
    id: getWallpapers
    running: true
    command: [Qt.resolvedUrl("./wallpaths.sh")]
    stdout: StdioCollector {
      onStreamFinished: {
        const paths = text.trim().split("\n");
        wallpicker.wallpaperPaths = paths;
      }
    }
  }

  Process {
    id: applyWallpaper
    running: false
    command: []
  }

  Control {
    padding: 7
    anchors.fill: parent

    contentItem: GridView {
      id: wallpapers
      model: wallpicker.wallpaperPaths
      cellWidth: width / 3
      cellHeight: (width / 3 - 5) * 0.5625
      clip: true
      cacheBuffer: 50
      reuseItems: true

      delegate: Item {
        width: wallpapers.cellWidth
        height: wallpapers.cellHeight

        Loader {
          anchors.fill: parent
          anchors.margins: 5
          active: true

          sourceComponent: Component {
            Item {
              MouseArea {
                anchors.fill: parent
                onClicked: {
                  applyWallpaper.command = ["awww", "img", modelData, "--transition-type", "center"];
                  applyWallpaper.running = true;
                }
              }

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

              Item {
                id: mask
                width: img.width
                height: img.height
                layer.enabled: true
                visible: false

                Rectangle {
                  radius: 6
                  color: "black"
                  width: img.width
                  height: img.height
                }
              }
            }
          }
        }
      }
    }
  }

  Timer {
    id: timer
    interval: 1000
    running: false

    onTriggered: {
      wallpicker.visible = false;
    }
  }

  MouseArea {
    id: area
    hoverEnabled: true
    anchors.fill: parent
    propagateComposedEvents: true  // Add this line

    onExited: {
      timer.running = true;
    }

    onEntered: {
      timer.running = false;
      timer.interval = 1000;
    }
  }
}
