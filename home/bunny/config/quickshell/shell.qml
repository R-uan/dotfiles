//@ pragma UseQApplication
import "taskbar"
import "quickmenu"

import QtQuick
import Quickshell

ShellRoot {
  Bar {
    id: taskbar
  }
  QuickMenu {
    id: quickMenu
  }
}
