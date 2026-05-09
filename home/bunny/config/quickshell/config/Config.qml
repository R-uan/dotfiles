pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property string homeShortcutDir: "/mnt/hdd/home"
  property string assetsDir: Quickshell.shellPath("assets")
  property string scriptsDir: Quickshell.shellPath("scripts")
}