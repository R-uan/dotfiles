//@ pragma UseQApplication
//@ pragma Env QS_DISABLE_FILE_WATCHER=false

import "windows/taskbar"
import "windows/startmenu"
import "windows/wallpapers"

import QtQuick
import Quickshell

ShellRoot {
  Taskbar {
    id: taskbar
  }

  Startmenu {
    id: startmenu
  }

  Wallpapers {
    id: wallpapers
  }
}
