import qs.shared
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts

// Folder settings: the base home, the start menu quick access paths and the
// recordings / wallpaper folders. Written to Config.settings (~/.local/state/
// quickshell/settings.json). An empty field means the default shown in it;
// relative paths are taken from the base home, "~" is your real $HOME.
DockedPanel {
  id: settingsMenu
  edge: "center"
  visible: false
  objectName: "Settings"
  cardWidth: 460
  cardHeight: layout.implicitHeight + 28
  modal: true
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

  readonly property color _fg:   Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _acc:  Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color _dim:  Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _mute: Config.darkMode ? ThemeDark.muted       : ThemeLight.muted

  // Resolved path -> whether it is an existing directory.
  property var exists: ({})

  onVisibleChanged: if (visible) checkPaths()

  IpcHandler {
    target: "settings"
    function toggle(): void { settingsMenu.visible = !settingsMenu.visible; }
  }

  readonly property var _allPaths: [Config.homeDir, Config.recordingsDir, Config.wallpaperDir]
    .concat(Config.homeFolders.map(f => Config.folderPath(f.key)))
  on_AllPathsChanged: if (visible) checkPaths()

  function checkPaths() {
    checkProc.paths = _allPaths;
    checkProc.running = false;
    checkProc.running = true;
  }

  Process {
    id: checkProc
    property var paths: []
    command: ["sh", "-c", 'for p; do [ -d "$p" ] && echo 1 || echo 0; done', "sh"].concat(paths)
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        const out = {};
        checkProc.paths.forEach((p, i) => out[p] = lines[i] === "1");
        settingsMenu.exists = out;
      }
    }
  }

  // Overrides for one folder key; "" clears it.
  function setFolder(key, value) {
    const f = Object.assign({}, Config.settings.folders);
    if (value) f[key] = value; else delete f[key];
    Config.settings.folders = f;
  }

  function resetAll() {
    Config.settings.homeDir = "";
    Config.settings.recordingsDir = "";
    Config.settings.wallpaperDir = "";
    Config.settings.folders = {};
  }

  // ── A labelled path field ──────────────────────────────────────
  component PathRow: RowLayout {
    id: row
    property string label
    property string value          // the stored override
    property string fallback       // shown when value is empty
    property string resolved       // what it resolves to now
    signal commit(string value)

    Layout.fillWidth: true
    spacing: 8

    StyledText {
      Layout.preferredWidth: 86
      text: row.label
      font.pixelSize: Config.fontSize - 2
      color: settingsMenu._fg
      elide: Text.ElideRight
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      radius: 8
      color: Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04)
      border.width: 1
      border.color: input.activeFocus
        ? settingsMenu._dim
        : (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.10))
      Behavior on border.color { CAnim {} }

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 6
        spacing: 6

        // Exists / missing
        Rectangle {
          readonly property bool ok: settingsMenu.exists[row.resolved] !== false
          implicitWidth: 6
          implicitHeight: 6
          radius: 3
          color: ok ? settingsMenu._dim : "transparent"
          border.width: ok ? 0 : 1
          border.color: settingsMenu._acc
        }

        TextInput {
          id: input
          Layout.fillWidth: true
          verticalAlignment: TextInput.AlignVCenter
          font.family: Config.fontFamily
          font.pixelSize: Config.fontSize - 3
          color: settingsMenu._fg
          selectByMouse: true
          selectionColor: settingsMenu._dim
          clip: true
          text: row.value
          onEditingFinished: if (text.trim() !== row.value) row.commit(text.trim())
          Keys.onEscapePressed: { text = row.value; settingsMenu.visible = false; }

          StyledText {
            visible: input.text.length === 0
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            text: row.fallback
            elide: Text.ElideLeft
            font.pixelSize: Config.fontSize - 3
            color: settingsMenu._mute
          }
        }

        // Back to the default
        StyledText {
          visible: row.value.length > 0
          text: "󰕌"
          font.pixelSize: Config.fontSize - 2
          color: resetMa.containsMouse ? settingsMenu._fg : settingsMenu._dim
          MouseArea {
            id: resetMa
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: row.commit("")
          }
        }
      }
    }
  }

  component SectionLabel: StyledText {
    Layout.topMargin: 8
    font.pixelSize: Config.fontSize - 4
    font.letterSpacing: 1.2
    color: settingsMenu._dim
  }

  ColumnLayout {
    id: layout
    anchors.fill: parent
    anchors.margins: 14
    spacing: 6

    // ── Header ───────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      StyledText {
        text: "󰒓"
        font.pixelSize: Config.fontSize + 2
        color: settingsMenu._acc
      }
      StyledText {
        Layout.fillWidth: true
        text: "Folders"
        font.pixelSize: Config.fontSize
        font.weight: Font.Medium
        color: settingsMenu._fg
      }
      StyledText {
        text: "reset all"
        font.pixelSize: Config.fontSize - 3
        color: resetAllMa.containsMouse ? settingsMenu._fg : settingsMenu._dim
        MouseArea {
          id: resetAllMa
          anchors.fill: parent
          anchors.margins: -4
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: settingsMenu.resetAll()
        }
      }
      StyledText {
        text: "󰅖"
        font.pixelSize: Config.fontSize
        color: closeMa.containsMouse ? settingsMenu._fg : settingsMenu._dim
        MouseArea {
          id: closeMa
          anchors.fill: parent
          anchors.margins: -4
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: settingsMenu.visible = false
        }
      }
    }

    // ── Base home ────────────────────────────────────────────
    SectionLabel { text: "BASE HOME" }
    PathRow {
      label: "home"
      value: Config.settings.homeDir
      fallback: Config.defaultHomeDir
      resolved: Config.homeDir
      onCommit: (v) => Config.settings.homeDir = v
    }

    // ── Quick access ─────────────────────────────────────────
    SectionLabel { text: "QUICK ACCESS" }
    Repeater {
      // "home" is the base home itself, set above.
      model: Config.homeFolders.filter(f => f.key !== "home")
      delegate: PathRow {
        required property var modelData
        label: modelData.label
        value: Config.settings.folders[modelData.key] || ""
        fallback: Config.defaultFolderPath(modelData.key)
        resolved: Config.folderPath(modelData.key)
        onCommit: (v) => settingsMenu.setFolder(modelData.key, v)
      }
    }

    // ── Other folders ────────────────────────────────────────
    SectionLabel { text: "OTHER" }
    PathRow {
      label: "recordings"
      value: Config.settings.recordingsDir
      fallback: Config.homeDir + "/videos/recordings"
      resolved: Config.recordingsDir
      onCommit: (v) => Config.settings.recordingsDir = v
    }
    PathRow {
      label: "wallpapers"
      value: Config.settings.wallpaperDir
      fallback: Config.homeDir + "/images/wallpapers"
      resolved: Config.wallpaperDir
      onCommit: (v) => Config.settings.wallpaperDir = v
    }

    StyledText {
      Layout.topMargin: 6
      Layout.fillWidth: true
      wrapMode: Text.WordWrap
      text: "Empty uses the default · relative paths start at the base home · hollow dot: folder missing"
      font.pixelSize: Config.fontSize - 5
      color: settingsMenu._mute
    }
  }
}
