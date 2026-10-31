pragma Singleton

import QtQuick
import Quickshell

Singleton {
  // Folder Paths
  property string homeShortcutDir: "/mnt/hdd/home"
  property string recordingsDir: "/mnt/hdd/home/videos/recordings"
  property string wallpaperDir: "/mnt/hdd/home/images/wallpapers"
  property string assetsDir: Quickshell.shellPath("assets")
  property string scriptsDir: Quickshell.shellPath("scripts")

  // Programs
  // Prefix used to run desktop entries that declare Terminal=true.
  property var terminalCommand: ["kitty", "-e"]

  // Start menu. App icons are nerd-font glyphs; `launcher: true` opens the
  // app launcher. Folders are relative to homeShortcutDir unless absolute.
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
  property var startMenuFolders: [
    { label: "downloads", folder: "downloads" },
    { label: "documents", folder: "documents" },
    { label: "images",    folder: "images"    },
    { label: "music",     folder: "music"     },
    { label: "code",      folder: "code"      },
    { label: "desktop",   folder: "desktop"   },
    { label: "dotfiles",  folder: "/home/bunny/dotfiles/" }
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
