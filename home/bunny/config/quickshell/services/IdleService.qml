pragma Singleton

import QtQuick
import Quickshell

// "Caffeine" state. The actual IdleInhibitor lives on the taskbar window
// (Taskbar.qml): Hyprland only honours inhibitors on visible surfaces, and
// the bar is the one surface that is always mapped.
Singleton {
  id: root

  property bool inhibited: false

  readonly property string icon: inhibited ? "󰅶" : "󰛊"

  function toggle() { root.inhibited = !root.inhibited; }
}
