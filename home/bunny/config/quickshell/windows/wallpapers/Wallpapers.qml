import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

// Wallpaper picker: big preview of the hovered/selected wallpaper over a
// thumbnail grid. Thumbnails live in the freedesktop cache (shared with
// file managers) and are generated once with ImageMagick.
// Keys: type to filter · arrows move · Enter apply · Esc clear/close.
DockedPanel {
  id: wallpapers
  edge: "full"
  visible: false
  cardWidth: 480
  objectName: "Wallpapers"
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

  readonly property color colFg:   Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color colAcc:  Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color colDim:  Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color colTile: Config.darkMode ? Qt.rgba(1,1,1,0.04)   : Qt.rgba(0,0,0,0.04)
  readonly property color colLine: Config.darkMode ? Qt.rgba(1,1,1,0.10)   : Qt.rgba(0,0,0,0.10)

  property alias timer: hideTimer
  property var wallpaperPaths: []
  property bool loading: true
  property string searchQuery: ""
  property int selectedIndex: -1
  property string hoveredPath: ""
  property int thumbsDone: 0
  property int thumbsPending: 0
  signal thumbsGenerated()

  readonly property int columns: 3

  readonly property var filteredPaths: {
    if (searchQuery.length === 0) return wallpaperPaths;
    const words = searchQuery.toLowerCase().split(/\s+/).filter(w => w.length > 0);
    return wallpaperPaths.filter(p => {
      const name = p.split("/").pop().toLowerCase();
      return words.every(w => name.includes(w));
    });
  }

  // What the preview shows: hover beats keyboard selection beats current.
  readonly property string previewPath: hoveredPath.length > 0 ? hoveredPath
    : (selectedIndex >= 0 && selectedIndex < filteredPaths.length ? filteredPaths[selectedIndex]
    : WallpaperService.wallpaperPath)

  readonly property string _thumbDir: (Quickshell.env("XDG_CACHE_HOME") || Quickshell.env("HOME") + "/.cache")
                                      + "/thumbnails/large/"

  // Freedesktop thumbnail name: md5 of the file URI.
  function thumbPath(path) {
    return _thumbDir + Qt.md5("file://" + encodeURI(path)) + ".png";
  }

  function nameOf(path) { return path.split("/").pop().replace(/\.[^.]+$/, ""); }

  function apply(path) {
    if (!path) return;
    applyWallpaper.command = ["awww", "img", path,
      "--transition-type", "grow", "--transition-pos", "left",
      "--transition-duration", "1.2", "--transition-fps", "60"];
    applyWallpaper.running = true;
  }

  function pickRandom() {
    const list = wallpapers.filteredPaths;
    if (list.length === 0) return;
    let choice;
    let i = 0;
    do {
      choice = list[Math.floor(Math.random() * list.length)];
      i++;
    } while (choice === WallpaperService.wallpaperPath && list.length > 1 && i < 10);
    wallpapers.apply(choice);
  }

  function moveSelection(delta) {
    const n = filteredPaths.length;
    if (n === 0) return;
    const cur = selectedIndex < 0 ? Math.max(0, filteredPaths.indexOf(WallpaperService.wallpaperPath)) : selectedIndex;
    selectedIndex = Math.max(0, Math.min(n - 1, cur + delta));
    hoveredPath = "";
    grid.positionViewAtIndex(selectedIndex, GridView.Contain);
  }

  function generateThumbs() {
    const args = [];
    for (const p of wallpaperPaths) args.push(p, thumbPath(p));
    if (args.length === 0) return;
    wallpapers.thumbsDone = 0;
    wallpapers.thumbsPending = wallpaperPaths.length;
    thumbProc.command = [Config.scriptsDir + "/genthumbs.sh"].concat(args);
    thumbProc.running = true;
  }

  onVisibleChanged: {
    if (visible) {
      getWallpapers.running = true;
      selectedIndex = -1;
      hoveredPath = "";
      searchField.text = "";
      searchField.forceActiveFocus();
    }
  }

  onFilteredPathsChanged: if (selectedIndex >= filteredPaths.length) selectedIndex = filteredPaths.length - 1

  Process {
    id: getWallpapers
    running: true
    command: [Qt.resolvedUrl("./wallpaths.sh"), Config.wallpaperDir]
    stdout: StdioCollector {
      onStreamFinished: {
        wallpapers.wallpaperPaths = text.trim().split("\n").filter(l => l.length > 0);
        wallpapers.loading = false;
        wallpapers.generateThumbs();
      }
    }
    onStarted: wallpapers.loading = true
  }

  // Prints one line per thumbnail it had to make; existing ones are skipped.
  Process {
    id: thumbProc
    stdout: SplitParser {
      onRead: wallpapers.thumbsDone++
    }
    onExited: {
      if (wallpapers.thumbsDone > 0) wallpapers.thumbsGenerated();
      wallpapers.thumbsPending = 0;
    }
  }

  Process {
    id: applyWallpaper
    running: false
    command: []
    onExited: WallpaperService.refresh()
  }

  Timer {
    id: hideTimer
    interval: 1000
    running: false
    onTriggered: wallpapers.visible = false
  }

  HoverHandler {
    onHoveredChanged: {
      if (hovered) hideTimer.stop();
      else if (!scrollBar.pressed) hideTimer.restart();
    }
  }

  component IconButton: Rectangle {
    id: ib
    property string glyph
    signal clicked()
    implicitWidth: 26
    implicitHeight: 26
    radius: 7
    color: ibMa.containsMouse ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08)) : wallpapers.colTile
    Behavior on color { CAnim {} }
    StyledText {
      anchors.centerIn: parent
      text: ib.glyph
      font.pixelSize: Config.fontSize - 1
      color: wallpapers.colFg
    }
    MouseArea {
      id: ibMa
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: ib.clicked()
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 14
    spacing: 10

    // ── Header ──────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      StyledText {
        text: "󰸉"
        color: wallpapers.colAcc
        font.pixelSize: Config.fontSize + 4
      }
      StyledText {
        text: "Wallpapers"
        color: wallpapers.colFg
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: wallpapers.thumbsPending > 0 && wallpapers.thumbsDone > 0
          ? "thumbnails " + wallpapers.thumbsDone + "…"
          : wallpapers.filteredPaths.length + (wallpapers.searchQuery.length > 0
              ? " / " + wallpapers.wallpaperPaths.length : "")
        color: wallpapers.colDim
        font.pixelSize: Config.fontSize - 4
      }
      IconButton { glyph: "󰒝"; onClicked: wallpapers.pickRandom() }
      IconButton { glyph: "󰑐"; onClicked: getWallpapers.running = true }
    }

    // ── Preview ─────────────────────────────────────────────
    Item {
      id: preview
      Layout.fillWidth: true
      Layout.preferredHeight: Math.round(width * 9 / 16)

      readonly property bool isCurrent: wallpapers.previewPath === WallpaperService.wallpaperPath

      Image {
        id: previewImg
        anchors.fill: parent
        visible: false
        source: wallpapers.previewPath ? "file://" + wallpapers.previewPath : ""
        sourceSize.width: 960
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        // Keep showing the previous image until the next one is ready.
        cache: true
      }
      MultiEffect {
        anchors.fill: parent
        source: previewImg
        maskEnabled: true
        maskSource: previewMask
        opacity: previewImg.status === Image.Ready ? 1 : 0
        Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
      }
      Item {
        id: previewMask
        anchors.fill: parent
        layer.enabled: true
        visible: false
        Rectangle { anchors.fill: parent; radius: 12; color: "black" }
      }

      // Caption
      Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 52
        radius: 12
        gradient: Gradient {
          GradientStop { position: 0.0; color: "transparent" }
          GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.75) }
        }
      }
      RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        spacing: 8

        StyledText {
          Layout.fillWidth: true
          text: wallpapers.previewPath ? wallpapers.nameOf(wallpapers.previewPath) : ""
          elide: Text.ElideRight
          font.pixelSize: Config.fontSize - 2
          color: "#f0f0f0"
        }
        Rectangle {
          implicitWidth: badge.implicitWidth + 14
          implicitHeight: 22
          radius: 11
          color: preview.isCurrent ? Qt.rgba(1, 1, 1, 0.18)
               : (applyMa.containsMouse ? Qt.rgba(1, 1, 1, 0.30) : Qt.rgba(1, 1, 1, 0.18))
          Behavior on color { CAnim {} }
          StyledText {
            id: badge
            anchors.centerIn: parent
            text: preview.isCurrent ? "current" : "apply"
            font.pixelSize: Config.fontSize - 4
            font.letterSpacing: 1
            color: "#f0f0f0"
          }
          MouseArea {
            id: applyMa
            anchors.fill: parent
            enabled: !preview.isCurrent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: wallpapers.apply(wallpapers.previewPath)
          }
        }
      }
    }

    // ── Search ──────────────────────────────────────────────
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      radius: 8
      color: wallpapers.colTile
      border.color: searchField.activeFocus ? wallpapers.colLine : "transparent"
      border.width: 1

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 6

        StyledText {
          text: "󰍉"
          font.pixelSize: Config.fontSize - 1
          color: wallpapers.colDim
        }

        TextInput {
          id: searchField
          Layout.fillWidth: true
          verticalAlignment: TextInput.AlignVCenter
          font.pixelSize: Config.fontSize - 2
          font.family: Config.fontFamily
          color: wallpapers.colFg
          selectByMouse: true
          clip: true
          onTextChanged: {
            wallpapers.searchQuery = text;
            wallpapers.selectedIndex = text.length > 0 ? 0 : -1;
          }

          Keys.onPressed: (event) => {
            const cols = wallpapers.columns;
            if (event.key === Qt.Key_Escape) {
              if (text.length > 0) text = "";
              else wallpapers.visible = false;
            } else if (event.key === Qt.Key_Down) {
              wallpapers.moveSelection(cols);
            } else if (event.key === Qt.Key_Up) {
              wallpapers.moveSelection(-cols);
            } else if (event.key === Qt.Key_Right && text.length === 0 || event.key === Qt.Key_Tab) {
              wallpapers.moveSelection(1);
            } else if (event.key === Qt.Key_Left && text.length === 0 || event.key === Qt.Key_Backtab) {
              wallpapers.moveSelection(-1);
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              const p = wallpapers.filteredPaths[Math.max(0, wallpapers.selectedIndex)];
              wallpapers.apply(p);
            } else {
              return;
            }
            event.accepted = true;
          }

          StyledText {
            visible: searchField.text.length === 0
            anchors.verticalCenter: parent.verticalCenter
            text: "type to filter · arrows · enter"
            font.pixelSize: Config.fontSize - 3
            color: wallpapers.colDim
          }
        }
      }
    }

    StyledText {
      visible: !wallpapers.loading && wallpapers.filteredPaths.length === 0
      Layout.fillWidth: true
      Layout.topMargin: 20
      horizontalAlignment: Text.AlignHCenter
      text: wallpapers.searchQuery.length > 0 ? "No matches" : "No wallpapers in " + Config.wallpaperDir
      color: wallpapers.colDim
      font.pixelSize: Config.fontSize - 2
    }

    // ── Grid ────────────────────────────────────────────────
    GridView {
      id: grid
      visible: wallpapers.filteredPaths.length > 0
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: wallpapers.filteredPaths
      cellWidth: Math.floor(width / wallpapers.columns)
      cellHeight: Math.floor(cellWidth * 10 / 16)
      clip: true
      cacheBuffer: 600
      boundsBehavior: Flickable.StopAtBounds

      ScrollBar.vertical: ScrollBar {
        id: scrollBar
        policy: ScrollBar.AsNeeded
        width: 5
        contentItem: Rectangle {
          radius: 3
          color: Config.darkMode ? Qt.rgba(1,1,1,0.20) : Qt.rgba(0,0,0,0.20)
        }
      }

      delegate: Item {
        id: cell
        required property string modelData
        required property int index
        width: grid.cellWidth
        height: grid.cellHeight

        readonly property bool isActive: WallpaperService.wallpaperPath === modelData
        readonly property bool isSelected: wallpapers.selectedIndex === index

        Item {
          anchors.fill: parent
          anchors.margins: 3
          scale: cellMa.pressed ? 0.95 : 1
          Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }

          Rectangle {
            anchors.fill: parent
            radius: 8
            color: wallpapers.colTile
          }

          Image {
            id: thumb
            // Falls back to the original until the cached thumbnail exists.
            property bool fallback: false
            anchors.fill: parent
            visible: false
            source: fallback ? "file://" + cell.modelData : "file://" + wallpapers.thumbPath(cell.modelData)
            sourceSize.width: 256
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            onStatusChanged: if (status === Image.Error && !fallback) fallback = true

            Connections {
              target: wallpapers
              function onThumbsGenerated() { if (thumb.fallback) thumb.fallback = false; }
            }
          }
          MultiEffect {
            anchors.fill: parent
            source: thumb
            maskEnabled: true
            maskSource: thumbMask
            opacity: thumb.status === Image.Ready ? 1 : 0
            Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
          }
          Item {
            id: thumbMask
            anchors.fill: parent
            layer.enabled: true
            visible: false
            Rectangle { anchors.fill: parent; radius: 8; color: "black" }
          }

          // Selection / current outline
          Rectangle {
            anchors.fill: parent
            radius: 8
            color: "transparent"
            border.width: cell.isActive || cell.isSelected || cellMa.containsMouse ? 2 : 0
            border.color: cell.isActive ? wallpapers.colFg
                        : cell.isSelected ? wallpapers.colAcc
                        : Qt.rgba(1, 1, 1, 0.35)
          }

          // Current marker
          Rectangle {
            visible: cell.isActive
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 5
            width: 16
            height: 16
            radius: 8
            color: wallpapers.colFg
            StyledText {
              anchors.centerIn: parent
              text: "󰄬"
              font.pixelSize: 10
              color: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
            }
          }

          MouseArea {
            id: cellMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onContainsMouseChanged: {
              if (containsMouse) wallpapers.hoveredPath = cell.modelData;
              else if (wallpapers.hoveredPath === cell.modelData) wallpapers.hoveredPath = "";
            }
            onClicked: {
              wallpapers.selectedIndex = cell.index;
              wallpapers.apply(cell.modelData);
            }
          }
        }
      }
    }
  }
}
