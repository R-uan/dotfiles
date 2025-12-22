import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import ".." as Root
import "."

PanelWindow {
  id: wallPicker
  property int maxRows: 2
  property int totalWallpapers: 10
  property int miniatureWidth: 256
  property int miniatureHeight: 144

  visible: false
  color: "transparent"
  margins.bottom: 4
  exclusionMode: ExclusionMode.Ignore
  implicitHeight: (maxRows * miniatureHeight) + (7 * maxRows - 1) + 14
  implicitWidth: ((totalWallpapers / maxRows) * miniatureWidth) + (7 * totalWallpapers / maxRows - 1) + 14

  anchors {
    bottom: true
  }

  Component.onCompleted: {
    WallpaperService.loadWallpapers();
  }

  Rectangle {
    radius: Root.Theme.radius
    anchors.fill: parent
    color: "red" // Root.Theme.background
    border.width: 2
    opacity: 0.90
    border.color: Root.Theme.borderColour
  }

  ColumnLayout {
    id: wallpapers
    spacing: 7
    anchors.centerIn: parent

    Repeater {
      // This will automatically update when the arrays change
      model: WallpaperService.topImages.length > 0 || WallpaperService.bottomImages.length > 0
             ? [WallpaperService.topImages, WallpaperService.bottomImages] : []

      delegate: RowLayout {
        spacing: 7
        Layout.fillWidth: true
        Layout.preferredHeight: miniatureHeight
        Repeater {
          model: modelData

          delegate: Item {
            Layout.preferredWidth: miniatureWidth
            Layout.preferredHeight: miniatureHeight

            Image {
              anchors.fill: parent
              source: modelData
              fillMode: Image.PreserveAspectCrop
              sourceSize: Qt.size(miniatureWidth, miniatureHeight)
            }
          }
        }
      }
    }
  }
}
