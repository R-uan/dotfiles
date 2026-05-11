pragma Singleton

import QtQuick
import Quickshell

Singleton {
  // Folder Paths
  property string homeShortcutDir: "/mnt/hdd/home"
  property string assetsDir: Quickshell.shellPath("assets")
  property string scriptsDir: Quickshell.shellPath("scripts")

  // General Configs
  property real backgroundOpacity: 0.99
  property bool darkMode: true
  property int thickness: 35
  property int rounding: 16
  property int spacing: 5
  property int margins: 0
  property int radius: 6

  // Font
  property int fontSize: 14
  property int fontWeight: 400
  property string fontFamily: "Iosevka"
}