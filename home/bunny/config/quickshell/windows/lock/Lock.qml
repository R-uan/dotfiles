import qs.config

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

// Lock screen (replaces hyprlock). `qs ipc call lock lock`, Super+L,
// the session screen and hypridle all come through lock().
//
// Uses the ext-session-lock protocol, so if quickshell dies while locked
// the session stays locked (Hyprland shows its fallback screen); hypridle's
// lock_cmd falls back to hyprlock when quickshell isn't running at all.
//
// Authenticates against /etc/pam.d/quickshell (security.pam.services in
// modules/system/security.nix).
Scope {
  id: root

  property bool locked: false
  // "" idle · "checking" · "failed" (wrong password) · "error" (PAM itself)
  property string status: ""
  property string message: ""
  signal failed()

  property string _pw: ""

  function lock() {
    if (locked) return;
    status = "";
    message = "";
    locked = true;
  }

  function tryUnlock(pw) {
    if (pam.active || pw.length === 0) return;
    _pw = pw;
    status = "checking";
    message = "";
    if (!pam.start()) {
      _pw = "";
      status = "error";
      message = "Couldn't start authentication";
      failed();
    }
  }

  PamContext {
    id: pam
    config: "quickshell"

    onResponseRequiredChanged: {
      if (!responseRequired) return;
      respond(root._pw);
      root._pw = "";
    }

    onCompleted: (result) => {
      root._pw = "";
      if (result === PamResult.Success) {
        root.status = "";
        root.locked = false;
        return;
      }
      root.status = "failed";
      root.message = result === PamResult.MaxTries ? "Too many attempts" : "Wrong password";
      root.failed();
    }

    onError: (error) => {
      root._pw = "";
      root.status = "error";
      root.message = "Authentication error: " + PamError.toString(error);
      root.failed();
    }
  }

  WlSessionLock {
    locked: root.locked

    WlSessionLockSurface {
      color: "black"

      LockSurface {
        anchors.fill: parent
        ctx: root
      }
    }
  }

  IpcHandler {
    target: "lock"
    function lock(): void { root.lock(); }
    function isLocked(): bool { return root.locked; }
  }
}
