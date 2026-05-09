pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property string assetsDir: Quickshell.shellPath("assets")
  property string scriptsDir: Quickshell.shellPath("scripts")
}