pragma Singleton

import QtQuick
import Quickshell

Singleton {
  // Folder Paths
  property string homeShortcutDir: "/mnt/hdd/home"
  property string assetsDir: Quickshell.shellPath("assets")
  property string scriptsDir: Quickshell.shellPath("scripts")

  // Programs
  // Prefix used to run desktop entries that declare Terminal=true.
  property var terminalCommand: ["kitty", "-e"]

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
