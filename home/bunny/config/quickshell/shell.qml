//@ pragma UseQApplication
import "taskbar"
import "quickmenu"
import "wallpicker"

import QtQuick
import Quickshell

ShellRoot {
  Bar {
    id: taskbar
  }

  QuickMenu {
    id: quickMenu
  }

  Wallpicker {
    id: wallpicker
  }
}
