pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Clipboard history backed by cliphist (fed by `wl-paste --watch cliphist
// store` from hyprland.lua). Entries are cliphist's own list lines, which
// are passed back to it verbatim on stdin for decode/delete.
Singleton {
  id: root

  // list of { line, id, text, isImage, w, h, format }
  property var entries: []
  property bool loading: false

  readonly property string imageDir: Quickshell.cachePath("clipboard")

  // "123\t[[ binary data 42 KiB png 1920x1080 ]]"
  readonly property var _imageRe: /^\[\[ binary data .* (\w+) (\d+)x(\d+) \]\]$/

  // The history only fills while wl-paste watchers feed cliphist. Start them
  // here (detached, so they outlive reloads) when they aren't already
  // running; Hyprland's start hook alone missed every session in which the
  // packages arrived after login.
  Component.onCompleted: {
    for (const type of ["text", "image"]) {
      Quickshell.execDetached(["sh", "-c",
        'pgrep -f "^wl-paste --type $1 --watch cliphist store" >/dev/null || exec wl-paste --type $1 --watch cliphist store',
        "sh", type]);
    }
  }

  function refresh() {
    root.loading = true;
    listProc.running = true;
  }

  // Copy an entry back onto the clipboard; with paste, also type Ctrl+V into
  // whatever window gets focus back once the panel has closed.
  function copy(entry, paste) {
    const script = 'printf "%s" "$1" | cliphist decode | wl-copy'
                   + (paste ? ' && sleep 0.15 && wtype -M ctrl v -m ctrl' : '');
    Quickshell.execDetached(["sh", "-c", script, "sh", entry.line]);
  }

  function remove(entry) {
    removeProc.command = ["sh", "-c", 'printf "%s" "$1" | cliphist delete', "sh", entry.line];
    removeProc.running = true;
    root.entries = root.entries.filter(e => e.id !== entry.id);
  }

  function wipe() {
    removeProc.command = ["cliphist", "wipe"];
    removeProc.running = true;
    root.entries = [];
  }

  function imagePath(entry) {
    return root.imageDir + "/" + entry.id + "." + entry.format;
  }

  Process {
    id: listProc
    command: ["cliphist", "list"]
    stdout: StdioCollector {
      onStreamFinished: {
        const out = [];
        for (const line of text.split("\n")) {
          const tab = line.indexOf("\t");
          if (tab < 0) continue;
          const preview = line.slice(tab + 1);
          const m = preview.match(root._imageRe);
          out.push({
            line: line,
            id: line.slice(0, tab),
            text: m ? "" : preview,
            isImage: !!m,
            format: m ? m[1] : "",
            w: m ? parseInt(m[2]) : 0,
            h: m ? parseInt(m[3]) : 0
          });
          if (out.length >= 200) break;
        }
        root.entries = out;
        root.loading = false;
      }
    }
    onExited: (code) => { if (code !== 0) root.loading = false; }
    // A missing binary never starts, so onExited never fires.
    onRunningChanged: if (!running) root.loading = false
  }

  Timer {
    running: root.loading
    interval: 3000
    onTriggered: root.loading = false
  }

  Process {
    id: removeProc
  }
}
