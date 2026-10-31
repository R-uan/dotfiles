pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  // Folder Paths. These are the defaults; the settings window overrides
  // them at runtime through ~/.local/state/quickshell/settings.json, since
  // this file is read-only in the nix store.
  readonly property string defaultHomeDir: "/mnt/hdd/home"
  readonly property string homeDir: _expand(settings.homeDir, "") || defaultHomeDir
  readonly property string recordingsDir: _expand(settings.recordingsDir, homeDir) || homeDir + "/videos/recordings"
  readonly property string wallpaperDir: _expand(settings.wallpaperDir, homeDir) || homeDir + "/images/wallpapers"

  // Start menu quick access, in grid order. Each opens homeDir/sub unless the
  // settings give it its own path.
  readonly property var homeFolders: [
    { key: "home",      label: "home",      sub: ""          },
    { key: "downloads", label: "downloads", sub: "downloads" },
    { key: "documents", label: "documents", sub: "documents" },
    { key: "code",      label: "code",      sub: "code"      },
    { key: "images",    label: "images",    sub: "images"    },
    { key: "music",     label: "music",     sub: "music"     },
    { key: "videos",    label: "videos",    sub: "videos"    },
    { key: "desktop",   label: "personal",  sub: "desktop"   }
  ]

  function defaultFolderPath(key) {
    const f = homeFolders.find(f => f.key === key);
    return f && f.sub ? homeDir + "/" + f.sub : homeDir;
  }

  function folderPath(key) {
    return _expand(settings.folders[key], homeDir) || defaultFolderPath(key);
  }

  // "~/x" -> $HOME/x; a relative path is taken from base (the home dir).
  function _expand(path, base) {
    if (!path) return "";
    path = path.trim().replace(/\/+$/, "");
    if (path === "~" || path.startsWith("~/")) return Quickshell.env("HOME") + path.slice(1);
    if (path.startsWith("/") || !base) return path;
    return base + "/" + path;
  }

  property alias settings: settingsAdapter

  // Not Quickshell.statePath(): that is keyed by the shell's path, a nix
  // store path that changes on every rebuild.
  readonly property string _stateDir: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/quickshell"
  readonly property string settingsPath: _stateDir + "/settings.json"

  FileView {
    path: settingsPath
    printErrors: false
    onLoadFailed: Quickshell.execDetached(["mkdir", "-p", _stateDir])
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()

    JsonAdapter {
      id: settingsAdapter
      property string homeDir: ""
      property string recordingsDir: ""
      property string wallpaperDir: ""
      property var folders: ({})   // key -> path
    }
  }

  property string assetsDir: Quickshell.shellPath("assets")
  property string scriptsDir: Quickshell.shellPath("scripts")

  // Programs
  // Prefix used to run desktop entries that declare Terminal=true.
  property var terminalCommand: ["kitty", "-e"]

  // Start menu. App icons are nerd-font glyphs; `launcher: true` opens the
  // app launcher.
  property var startMenuApps: [
    { name: "Zen",         icon: "󰈹", command: ["zen"] },
    { name: "VSCode",      icon: "󰨞", command: ["code"] },
    { name: "XIVLauncher", icon: "󰊴", command: ["XIVLauncher.Core"] },
    { name: "Steam",       icon: "󰓓", command: ["steam"] },
    { name: "Vesktop",     icon: "󰙯", command: ["vesktop"] },
    { name: "Terminal",    icon: "", command: ["kitty"] },
    { name: "Siyuan",      icon: "", command: ["siyuan"] },
    { name: "All apps",    icon: "", launcher: true }
  ]

  // Window app id -> icon name, for apps whose desktop entry doesn't match
  // their app id (zen's entry is zen-beta.desktop, its windows say "zen").
  property var appIconOverrides: ({
    "zen": "zen-browser"
  })

  // Calendar: day/month names follow LC_TIME; holidays "BR" or "" for none.
  property string timeLocale: "pt_BR"
  property string calendarHolidays: "BR"

  // Weather (wttr.in). Empty location = guess from IP; otherwise a city name
  // such as "Sao Paulo", an airport code, or "lat,lon".
  property bool weatherEnabled: true
  property string weatherLocation: ""

  // General Configs
  property real backgroundOpacity: 1 
  property bool darkMode: true
  property int thickness: 40
  property int rounding: 16
  property int spacing: 5
  property int margins: 0
  property int radius: 6

  // Font
  property int fontSize: 14
  property int fontWeight: 400
  property string fontFamily: "Iosevka"
}
