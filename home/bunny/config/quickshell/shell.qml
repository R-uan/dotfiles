//@ pragma UseQApplication
import "windows/startmenu"
import "windows/wallpapers"
import "windows/taskbar"

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
