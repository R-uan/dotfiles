//@ pragma UseQApplication
//@ pragma Env QS_DISABLE_FILE_WATCHER=false

import "windows/taskbar"
import "windows/startmenu"
import "windows/powermenu"
import "windows/notificationcenter"
import "windows/networkmenu"
import "windows/resourcesmenu"
import "windows/bluetoothmenu"
import "windows/launcher"
import "windows/wallpapers"

import QtQuick
import Quickshell

ShellRoot {
  id: shellRoot

  function hideOthers(except) {
    const panels = [
      startmenu, powermenu, notificationcenter, networkmenu,
      resourcesmenu, bluetoothmenu, wallpapers, launcher
    ];
    for (let p of panels) {
      if (!p || p === except) continue;
      if (p.visible) {
        p.visible = false;
        if (p.timer) p.timer.running = false;
      }
    }
  }

  Taskbar {
    id: taskbar
  }

  Startmenu {
    id: startmenu
    onVisibleChanged: if (visible) shellRoot.hideOthers(startmenu)
  }

  PowerMenu {
    id: powermenu
    onVisibleChanged: if (visible) shellRoot.hideOthers(powermenu)
  }

  NotificationCenter {
    id: notificationcenter
    onVisibleChanged: if (visible) shellRoot.hideOthers(notificationcenter)
  }

  NetworkMenu {
    id: networkmenu
    onVisibleChanged: if (visible) shellRoot.hideOthers(networkmenu)
  }

  ResourcesMenu {
    id: resourcesmenu
    onVisibleChanged: if (visible) shellRoot.hideOthers(resourcesmenu)
  }

  BluetoothMenu {
    id: bluetoothmenu
    onVisibleChanged: if (visible) shellRoot.hideOthers(bluetoothmenu)
  }

  Wallpapers {
    id: wallpapers
    onVisibleChanged: if (visible) shellRoot.hideOthers(wallpapers)
  }

  Launcher {
    id: launcher
    onVisibleChanged: if (visible) shellRoot.hideOthers(launcher)
  }
}
