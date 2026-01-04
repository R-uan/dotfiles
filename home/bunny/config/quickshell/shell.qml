//@ pragma UseQApplication
import "taskbar"
import "wallpicker"
import "quickmenu"
import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import qs.taskbar.modules

ShellRoot {
  Bar {
    id: taskbar
  }
  QuickMenu {
    id: quickMenu
  }
}
