import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
  id: wallpapers
  visible: false
  implicitWidth: 480
  color: "transparent"
  exclusionMode: ExclusionMode.Normal

  anchors {
    top: true
    left: true
    bottom: true
    right: false
  }

  readonly property color colForeground0: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color colPrimary0:    Config.darkMode ? ThemeDark.primary0    : ThemeLight.primary0
  readonly property color colPrimary1:    Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color colPrimary3:    Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color colBackground1: Config.darkMode ? ThemeDark.background1 : ThemeLight.background1
  readonly property color colBorder:      Config.darkMode ? ThemeDark.border      : ThemeLight.border
  readonly property color colColour5:     Config.darkMode ? ThemeDark.colour5     : ThemeLight.colour4
  readonly property color colColour3:     Config.darkMode ? ThemeDark.colour3     : ThemeLight.colour2
  readonly property color colOverlay:     Config.darkMode ? "#1a1a1a"             : "#2a2a2a"
  readonly property color colSuccess:     Config.darkMode ? ThemeDark.success     : ThemeLight.success

  property var wallpaperPaths: []
  property bool isHovered: false
  property bool loading: true
  property string searchQuery: ""

  readonly property var filteredPaths: {
    if (searchQuery.length === 0) return wallpaperPaths;
    const q = searchQuery.toLowerCase();
    return wallpaperPaths.filter(p => p.toLowerCase().includes(q));
  }

  margins {
    top: 4
    left: 4
    bottom: 4
  }

  Background {
    radius: 12
  }

  function apply(path) {
    applyWallpaper.command = ["awww", "img", path, "--transition-type", "center"];
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

  // — Fetch wallpaper paths —
  Process {
    id: getWallpapers
    running: true
    command: [Qt.resolvedUrl("./wallpaths.sh")]
    stdout: StdioCollector {
      onStreamFinished: {
        wallpapers.wallpaperPaths = text.trim().split("\n").filter(l => l.length > 0);
        wallpapers.loading = false;
      }
    }
    onStarted: wallpapers.loading = true
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

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    spacing: 10

    // ── Header ──────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      StyledText {
        text: "󰸉"
        color: wallpapers.colPrimary1
        font.pixelSize: Config.fontSize + 3
      }
      StyledText {
        text: "Wallpapers"
        color: wallpapers.colForeground0
        font.pixelSize: Config.fontSize + 1
        font.weight: Font.Medium
      }
      Item { Layout.fillWidth: true }

      StyledText {
        text: wallpapers.filteredPaths.length + (wallpapers.searchQuery.length > 0
          ? " / " + wallpapers.wallpaperPaths.length
          : "") + " wallpapers"
        color: wallpapers.colPrimary3
        font.pixelSize: Config.fontSize - 3
      }

      // Random button
      Item {
        implicitWidth: 26
        implicitHeight: 26
        Rectangle {
          anchors.fill: parent
          radius: 6
          color: randomBtn.containsMouse
            ? Qt.rgba(1,1,1, Config.darkMode ? 0.10 : 0.08)
            : Qt.rgba(1,1,1, Config.darkMode ? 0.04 : 0.04)
          border.color: Qt.rgba(1,1,1, Config.darkMode ? 0.06 : 0.06)
          border.width: 1
          Behavior on color { ColorAnimation { duration: 110 } }
        }
        StyledText {
          anchors.centerIn: parent
          text: "󰒲"
          font.pixelSize: Config.fontSize
          color: wallpapers.colForeground0
        }
        MouseArea {
          id: randomBtn
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: wallpapers.pickRandom()
        }
      }

      // Rescan button
      Item {
        implicitWidth: 26
        implicitHeight: 26
        Rectangle {
          anchors.fill: parent
          radius: 6
          color: rescanBtn.containsMouse
            ? Qt.rgba(1,1,1, Config.darkMode ? 0.10 : 0.08)
            : Qt.rgba(1,1,1, Config.darkMode ? 0.04 : 0.04)
          border.color: Qt.rgba(1,1,1, Config.darkMode ? 0.06 : 0.06)
          border.width: 1
          Behavior on color { ColorAnimation { duration: 110 } }
        }
        StyledText {
          anchors.centerIn: parent
          text: "󰑐"
          font.pixelSize: Config.fontSize
          color: wallpapers.colForeground0
        }
        MouseArea {
          id: rescanBtn
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: getWallpapers.running = true
        }
      }
    }

    // ── Search ──────────────────────────────────────────────
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      radius: 8
      color: Qt.rgba(1,1,1, Config.darkMode ? 0.04 : 0.04)
      border.color: searchField.activeFocus
        ? Qt.rgba(1,1,1, Config.darkMode ? 0.18 : 0.18)
        : Qt.rgba(1,1,1, Config.darkMode ? 0.06 : 0.06)
      border.width: 1

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 6

        StyledText {
          text: "󰍉"
          font.pixelSize: Config.fontSize - 1
          color: wallpapers.colPrimary3
        }

        TextInput {
          id: searchField
          Layout.fillWidth: true
          verticalAlignment: TextInput.AlignVCenter
          font.pixelSize: Config.fontSize - 2
          font.family: Config.fontFamily
          color: wallpapers.colForeground0
          selectByMouse: true
          clip: true
          onTextChanged: wallpapers.searchQuery = text
          Keys.onEscapePressed: {
            text = "";
            focus = false;
          }

          StyledText {
            visible: searchField.text.length === 0 && !searchField.activeFocus
            anchors.verticalCenter: parent.verticalCenter
            text: "filter…"
            font.pixelSize: Config.fontSize - 2
            color: wallpapers.colPrimary3
          }
        }

        Item {
          visible: searchField.text.length > 0
          implicitWidth: 16
          implicitHeight: 16
          StyledText {
            anchors.centerIn: parent
            text: "󰅖"
            font.pixelSize: Config.fontSize - 2
            color: wallpapers.colPrimary3
          }
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              searchField.text = "";
              searchField.focus = false;
            }
          }
        }
      }
    }

    // ── Loading state ──────────────────────────────────────
    StyledText {
      visible: wallpapers.loading && wallpapers.wallpaperPaths.length === 0
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      text: "Loading…"
      color: wallpapers.colPrimary3
      font.pixelSize: Config.fontSize - 1
    }

    // ── Empty state ────────────────────────────────────────
    StyledText {
      visible: !wallpapers.loading && wallpapers.filteredPaths.length === 0
      Layout.fillWidth: true
      Layout.topMargin: 20
      horizontalAlignment: Text.AlignHCenter
      text: wallpapers.searchQuery.length > 0 ? "No matches" : "No wallpapers found"
      color: wallpapers.colPrimary3
      font.pixelSize: Config.fontSize - 1
    }

    // ── Grid ────────────────────────────────────────────────
    GridView {
      id: wallpapersGrid
      visible: wallpapers.filteredPaths.length > 0
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: wallpapers.filteredPaths
      cellWidth: Math.floor(width / 2)
      // Landscape 16:9 aspect fits real wallpapers naturally
      cellHeight: Math.floor(cellWidth * 9 / 16) + 6
      clip: true
      cacheBuffer: 400
      reuseItems: true

      ScrollBar.vertical: ScrollBar {
        id: scrollBar
        policy: ScrollBar.AsNeeded
        interactive: true
        width: 8

        onPressedChanged: {
          if (pressed) hideTimer.running = false;
          else if (!wallpapers.isHovered) hideTimer.running = true;
        }

        contentItem: Rectangle {
          radius: 4
          color: scrollBar.pressed ? wallpapers.colPrimary0
               : scrollBar.hovered ? wallpapers.colColour5
                                   : wallpapers.colColour3
          Behavior on color { ColorAnimation { duration: 120 } }
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
        readonly property string wallName: wallPath.split("/").pop().replace(/\.[^.]+$/, "")
        readonly property bool isActive: WallpaperService.wallpaperPath === wallPath

        Item {
          anchors.fill: parent
          anchors.margins: 4

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

          Item {
            id: mask
            width: img.width
            height: img.height
            layer.enabled: true
            visible: false
            Rectangle {
              anchors.fill: parent
              radius: Config.radius * 1.6
              color: "black"
            }
          }

          // Bottom gradient for filename readability
          Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * 0.45
            radius: Config.radius * 1.6
            opacity: cellHover.containsMouse ? 0.85 : 0
            gradient: Gradient {
              GradientStop { position: 0.0; color: "transparent" }
              GradientStop { position: 1.0; color: "#000000" }
            }
            Behavior on opacity { NumberAnimation { duration: 150 } }
          }

          // Filename overlay
          StyledText {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 8
            text: delegateRoot.wallName
            font.pixelSize: Config.fontSize - 3
            color: "#f0f0f0"
            elide: Text.ElideRight
            opacity: cellHover.containsMouse ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
          }

          // Active indicator — checkmark in top-right
          Rectangle {
            visible: delegateRoot.isActive
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 6
            width: 22
            height: 22
            radius: 11
            color: wallpapers.colSuccess

            StyledText {
              anchors.centerIn: parent
              text: "󰄬"
              font.pixelSize: Config.fontSize - 2
              font.weight: Font.Bold
              color: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
            }
          }

          // Hover overlay tint
          Rectangle {
            anchors.fill: parent
            radius: Config.radius * 1.6
            color: wallpapers.colOverlay
            opacity: cellHover.containsMouse && !delegateRoot.isActive ? 0.25 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
          }

          // Selection border
          Rectangle {
            anchors.fill: parent
            radius: Config.radius * 1.6
            color: "transparent"
            border.color: delegateRoot.isActive
              ? wallpapers.colSuccess
              : wallpapers.colPrimary0
            border.width: delegateRoot.isActive ? 2 : (cellHover.containsMouse ? 2 : 0)
            Behavior on border.width { NumberAnimation { duration: 150 } }
          }

          MouseArea {
            id: cellHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: wallpapers.apply(delegateRoot.wallPath)
          }
        }
      }
    }
  }

  HoverHandler {
    onHoveredChanged: {
      wallpapers.isHovered = hovered;
      if (hovered) hideTimer.running = false;
      else if (!scrollBar.pressed) hideTimer.running = true;
    }
  }
}
