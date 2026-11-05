import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

// App launcher with prefix modes (same scheme as end-4's search):
//   (none) apps, plus matching actions and an inline answer for maths
//   >  apps only         /  shell actions     =  calculator (qalc)
//   :  emoji             ;  clipboard         $  shell command
//   ?  web search
// ↑↓ select · Enter open · Shift+Enter alternative (copy only /
// run in background) · Tab cycles an app's actions · Esc close.
// Usage (count + last time) is remembered across restarts and ranks results.
PanelWindow {
  id: launcher
  visible: false
  color: "transparent"
  objectName: "App Launcher"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell:launcher"
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

  anchors { top: true; left: true; right: true; bottom: true }

  // Panels the "/" actions open, set by shell.qml.
  property var session
  property var lockScreen
  property var overview
  property var wallpapers
  property var clipboardMenu
  property var settingsMenu

  readonly property int _topBarHeight: 7
  readonly property int _transitionSize: 16
  readonly property int _cornerRadius: 16
  readonly property int _cardWidth: 780
  readonly property int _cardHeight: 560
  readonly property int _rowHeight: 52
  readonly property int _maxRows: 80

  property alias timer: closeTimer
  property int selectedIndex: 0
  // -1: the item itself; otherwise which of the selected app's actions.
  property int actionIndex: -1
  property string query: ""
  property bool _presented: false
  readonly property color _cardColor: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
  readonly property color _fg:  Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _hi:  Config.darkMode ? ThemeDark.foreground1 : ThemeLight.foreground1
  readonly property color _dim: Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _sub: Config.darkMode ? ThemeDark.primary0    : ThemeLight.primary0
  // Unmatched part of a highlighted name.
  readonly property color _rest: Config.darkMode ? ThemeDark.colour6    : ThemeLight.colour6

  // ── Modes ───────────────────────────────────────────────────────────
  readonly property var modes: ({
    ">": { name: "Apps",       glyph: "󰀻" },
    "/": { name: "Actions",    glyph: "󰢻" },
    "=": { name: "Calculator", glyph: "󰃬" },
    ":": { name: "Emoji",      glyph: "󰇵" },
    ";": { name: "Clipboard",  glyph: "󰨸" },
    "$": { name: "Shell",      glyph: "󰆍" },
    "?": { name: "Web",        glyph: "󰖟" }
  })
  // Typing a prefix as the first character turns it into the mode chip and
  // takes it out of the text; Backspace on an empty field drops the chip.
  property string mode: ""
  readonly property string term: query.trim()

  // "=5 km to mi" -> mode "=", text "5 km to mi"; plain text stays as is.
  function setQuery(text) {
    mode = text.length > 0 && modes[text.charAt(0)] ? text.charAt(0) : "";
    searchField.text = mode ? text.slice(1) : text;
    searchField.cursorPosition = searchField.text.length;
    searchField.forceActiveFocus();
  }

  function openWith(text) {
    if (!visible) visible = true;
    setQuery(text);
  }

  // ── Usage memory (frecency) ─────────────────────────────────────────
  FileView {
    id: usageFile
    path: Config._stateDir + "/launcher.json"
    printErrors: false
    onAdapterUpdated: writeAdapter()
    JsonAdapter {
      id: usage
      property var items: ({})   // key -> { c: count, t: last use (ms) }
    }
  }

  function _frecency(key) {
    const u = usage.items[key];
    if (!u) return 0;
    const days = (Date.now() - (u.t || 0)) / 86400000;
    const w = days < 1 ? 1 : days < 7 ? 0.7 : days < 30 ? 0.4 : 0.2;
    return (u.c || 0) * w;
  }

  function _bump(key) {
    if (!key) return;
    const next = Object.assign({}, usage.items);
    const old = next[key] || {};
    next[key] = { c: (old.c || 0) + 1, t: Date.now() };
    usage.items = next;
  }

  // ── Matching ────────────────────────────────────────────────────────
  // Literal substring always outranks a scattered subsequence, so "code"
  // finds Code before anything containing c…o…d…e.
  // strict: literal matches only (for ids, generic names, keywords, where a
  // scattered subsequence is almost always noise).
  function _fieldScore(s, q, strict) {
    if (!s || s.length === 0) return -1;
    const trail = Math.min(60, Math.max(0, s.length - q.length));
    if (s === q) return 1000;
    if (s.startsWith(q)) return 800 - trail;
    if (s.indexOf(" " + q) >= 0) return 650 - trail;      // start of a word
    const initials = s.split(/[\s\-_.]+/).filter(w => w.length > 0).map(w => w.charAt(0)).join("");
    if (q.length > 1 && initials.startsWith(q)) return 600;  // "vsc" -> Visual Studio Code
    if (s.indexOf(q) >= 0) return 500 - trail;
    if (strict || q.length < 2) return -1;
    let i = 0, j = 0, first = -1, last = -1;
    while (i < s.length && j < q.length) {
      if (s.charAt(i) === q.charAt(j)) { if (first < 0) first = i; last = i; j++; }
      i++;
    }
    // Only a tight subsequence counts: "obsd" -> OBS Studio, not c…o…d…e
    // spread over a whole name.
    if (j !== q.length || last - first > q.length * 2) return -1;
    return 300 - Math.min(250, last - first);
  }

  // Accent-insensitive: "configuracoes" matches "Configurações".
  function _fold(s) {
    return (s || "").toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
  }

  function _appScore(e, q) {
    let best = _fieldScore(_fold(e.name), q);
    const g = _fieldScore(_fold(e.genericName), q, true);
    if (g >= 0) best = Math.max(best, g - 250);
    const k = _fieldScore(_fold((e.keywords || []).join(" ")), q, true);
    if (k >= 0) best = Math.max(best, k - 280);
    const i = _fieldScore((e.id || "").toLowerCase(), q, true);
    if (i >= 0) best = Math.max(best, i - 150);
    return best;
  }

  // Name with the matched characters in bold, as StyledText markup.
  function _esc(s) { return (s || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }
  function highlight(text, q) {
    if (!text) return "";
    if (!q) return _esc(text);
    const s = _fold(text);
    const marks = new Array(text.length).fill(false);
    const at = s.indexOf(q);
    if (at >= 0 && s.length === text.length) {
      for (let k = 0; k < q.length; k++) marks[at + k] = true;
    } else if (s.length === text.length) {
      let j = 0;
      for (let i = 0; i < s.length && j < q.length; i++)
        if (s.charAt(i) === q.charAt(j)) { marks[i] = true; j++; }
      if (j < q.length) return _esc(text);
    } else {
      return _esc(text);
    }
    // Matched runs bright and bold, the rest a step dimmer so they stand out.
    let out = "", run = "", runOn = marks[0];
    const flush = () => {
      if (!run) return;
      out += runOn ? "<b><font color=\"" + _hi + "\">" + run + "</font></b>"
                   : "<font color=\"" + _rest + "\">" + run + "</font>";
      run = "";
    };
    for (let i = 0; i < text.length; i++) {
      if (marks[i] !== runOn) { flush(); runOn = marks[i]; }
      run += _esc(text.charAt(i));
    }
    flush();
    return out;
  }

  // ── Sources ─────────────────────────────────────────────────────────
  readonly property var apps: (DesktopEntries.applications.values || []).filter(e => e && !e.noDisplay)

  // Quickshell's DesktopEntry.execute() ignores Terminal=true, so wrap those
  // (nvim, htop, …) in the configured terminal.
  function launchEntry(e) {
    if (e.runInTerminal && (e.command || []).length > 0) {
      Quickshell.execDetached(Config.terminalCommand.concat(Array.prototype.slice.call(e.command)));
      return;
    }
    e.execute();
  }

  function _appItem(e, q) {
    return {
      kind: "app", key: "app:" + (e.id || e.name), entry: e,
      title: highlight(e.name, q),
      desc: e.comment || e.genericName || "",
      icon: e.icon || "application-x-executable",
      actions: Array.prototype.slice.call(e.actions || []),
      run: (alt, ai) => {
        const acts = e.actions || [];
        if (ai >= 0 && ai < acts.length) acts[ai].execute();
        else launcher.launchEntry(e);
      }
    };
  }

  function _sh(cmd) { Quickshell.execDetached(["sh", "-c", cmd]); }

  // "/" actions. `on` (optional) shows the current state.
  readonly property var actions: [
    { id: "lock",      glyph: "󰌾", name: "Lock",              desc: "Lock the screen",                       run: () => launcher.lockScreen?.lock() },
    { id: "session",   glyph: "󰐥", name: "Session",           desc: "Lock, suspend, log out, restart, shut down", run: () => launcher.session?.show() },
    { id: "suspend",   glyph: "󰒲", name: "Suspend",           desc: "Sleep",                                 run: () => Quickshell.execDetached(["systemctl", "suspend"]) },
    { id: "logout",    glyph: "󰍃", name: "Log out",           desc: "Leave Hyprland",                        run: () => Hyprland.dispatch("hl.dsp.exit()") },
    { id: "reboot",    glyph: "󰜉", name: "Restart",           desc: "Reboot the computer",                   run: () => Quickshell.execDetached(["systemctl", "reboot"]) },
    { id: "poweroff",  glyph: "󰐥", name: "Shut down",         desc: "Power off",                             run: () => Quickshell.execDetached(["systemctl", "poweroff"]) },
    { id: "overview",  glyph: "󱇙", name: "Overview",          desc: "All workspaces and windows",            run: () => launcher.overview?.show() },
    { id: "wallpaper", glyph: "󰥶", name: "Wallpapers",        desc: "Pick a wallpaper",                      run: () => { if (launcher.wallpapers) launcher.wallpapers.visible = true; } },
    { id: "random",    glyph: "󰒟", name: "Random wallpaper",  desc: "Shuffle the wallpaper",                 run: () => launcher.wallpapers?.pickRandom() },
    { id: "clipboard", glyph: "󰨸", name: "Clipboard history", desc: "Or type ; here",                        run: () => { if (launcher.clipboardMenu) launcher.clipboardMenu.visible = true; } },
    { id: "settings",  glyph: "󰢻", name: "Folder settings",   desc: "Home, recordings and wallpaper folders", run: () => { if (launcher.settingsMenu) launcher.settingsMenu.visible = true; } },
    { id: "rec",       glyph: RecorderService.recording ? "󰙧" : "󰑋",
      name: RecorderService.recording ? "Stop recording" : "Record screen",
      desc: RecorderService.recording ? "Save the recording" : "Record the focused monitor",
      run: () => RecorderService.recording ? RecorderService.stop() : RecorderService.start("screen") },
    { id: "recregion", glyph: "󰩭", name: "Record region",     desc: "Select an area to record",              run: () => RecorderService.start("region") },
    { id: "caffeine",  glyph: "󰛊", name: "Caffeine",          desc: "Keep the screen awake", on: IdleService.inhibited, run: () => IdleService.toggle() },
    { id: "night",     glyph: "󰖔", name: "Night light",       desc: "Warmer colours",        on: SunsetService.enabled,  run: () => SunsetService.toggle() },
    { id: "dnd",       glyph: "󰪑", name: "Do not disturb",    desc: "Silence notifications", on: NotificationService.dnd, run: () => { NotificationService.dnd = !NotificationService.dnd; } }
  ]

  function _actionItem(a, q) {
    return {
      kind: "action", key: "action:" + a.id, glyph: a.glyph,
      title: highlight(a.name, q),
      desc: a.desc + (a.on === undefined ? "" : a.on ? "  ·  on" : "  ·  off"),
      run: () => a.run()
    };
  }

  // Calculator: qalc, debounced. Plain queries only count as maths when they
  // have a digit and an operator/conversion ("hello world" is valid qalc).
  property string calcResult: ""
  property string calcFor: ""
  property bool calcError: false
  readonly property string calcExpr: mode === "=" ? term
                                   : (mode === "" && _looksLikeMath(term) ? term : "")
  function _looksLikeMath(s) {
    return /\d/.test(s) && /[+\-*\/^%()]|\d\s*(to|in)\s+\w|sqrt|log|sin|cos|tan|!/.test(s)
           && !/^[a-z][a-z\s]*$/i.test(s);
  }
  onCalcExprChanged: { calcError = false; if (calcExpr) calcDebounce.restart(); }
  Timer {
    id: calcDebounce
    interval: 120
    onTriggered: {
      calcProc.running = false;
      calcProc.expr = launcher.calcExpr;
      calcProc.command = ["qalc", "-t", "--", launcher.calcExpr];
      calcProc.running = true;
    }
  }
  Process {
    id: calcProc
    property string expr: ""
    stdout: StdioCollector {
      onStreamFinished: {
        const out = text.trim().split("\n").pop() || "";
        launcher.calcFor = calcProc.expr;
        launcher.calcResult = out;
        launcher.calcError = out.length === 0;
      }
    }
    onExited: (code) => { if (code !== 0) launcher.calcError = true; }
  }

  function _copy(text) { Quickshell.execDetached(["wl-copy", "--", text]); }

  function _calcItem() {
    const ready = calcFor === calcExpr && calcResult.length > 0 && !calcError;
    return {
      kind: "calc", key: "", glyph: "󰃬",
      title: _esc(ready ? calcResult : (calcError ? "…" : "…")),
      desc: _esc(calcExpr) + (ready ? "  ·  Enter copies" : ""),
      run: () => { if (ready) launcher._copy(launcher.calcResult); }
    };
  }

  // Emoji: emoji \t group \t subgroup \t name \t keywords
  property var emojis: []
  FileView {
    path: Config.emojiFile
    printErrors: false
    onLoaded: {
      // The table lists some emoji twice (with and without the variation
      // selector); keep the first of each name.
      const out = [], seen = {};
      for (const line of text().split("\n")) {
        const f = line.split("\t");
        if (f.length < 4 || seen[f[3]]) continue;
        seen[f[3]] = true;
        out.push({ e: f[0], group: f[1], name: f[3], kw: (f[4] || "").toLowerCase(), tone: f[3].indexOf("skin tone") >= 0 });
      }
      launcher.emojis = out;
    }
  }

  function _emojiItems(q) {
    // Skin-tone variants only when asked for ("thumbs tone", "skin").
    const tones = q.indexOf("tone") >= 0 || q.indexOf("skin") >= 0;
    const scored = [];
    for (let i = 0; i < emojis.length; i++) {
      const x = emojis[i];
      if (!tones && x.tone) continue;
      const n = x.name.toLowerCase();
      // Shorter names first: "red heart" before "heart hands".
      let s = !q ? 0
            : (n === q ? 400 : n.startsWith(q) ? 300 : n.indexOf(" " + q) >= 0 ? 250
            : n.indexOf(q) >= 0 ? 200 : x.kw.indexOf(q) >= 0 ? 100 : -1000) - Math.min(40, n.length);
      if (s < -500) continue;
      scored.push({ x, i, s: s + Math.min(80, _frecency("emoji:" + x.e) * 10) });
    }
    const list = scored.sort((a, b) => b.s - a.s || a.i - b.i).slice(0, _maxRows).map(o => o.x);
    return list.map(x => ({
      kind: "emoji", key: "emoji:" + x.e, emoji: x.e,
      title: highlight(x.name.charAt(0).toUpperCase() + x.name.slice(1), q),
      desc: x.group,
      run: (alt) => {
        if (alt) launcher._copy(x.e);
        else Quickshell.execDetached(["sh", "-c", 'printf "%s" "$1" | wl-copy; sleep 0.15; wtype -- "$1"', "sh", x.e]);
      }
    }));
  }

  function _clipItems(q) {
    const out = [];
    for (const c of ClipboardService.entries) {
      const label = c.isImage ? "Image  " + c.w + "×" + c.h + " " + c.format : (c.text || "").replace(/\s+/g, " ").trim();
      if (q && _fold(label).indexOf(q) < 0) continue;
      out.push({
        kind: "clip", key: "", glyph: c.isImage ? "󰥶" : "󰨸",
        title: highlight(label.slice(0, 200), q),
        desc: c.isImage ? "Image" : "Text",
        run: (alt) => ClipboardService.copy(c, !alt)
      });
      if (out.length >= _maxRows) break;
    }
    return out;
  }

  function _shellItems(cmd) {
    if (!cmd) return [{ kind: "hint", key: "", glyph: "󰆍", title: "Type a command", desc: "Enter runs it in a terminal · Shift+Enter in the background", run: () => {} }];
    return [
      { kind: "shell", key: "", glyph: "󰆍", title: _esc(cmd), desc: "Run in a terminal  ·  Shift+Enter runs it in the background",
        run: (alt) => alt ? launcher._sh(cmd)
                          : Quickshell.execDetached(Config.terminalCommand.concat(["sh", "-c", cmd + '; exec "${SHELL:-sh}"'])) }
    ];
  }

  function _webItem(q) {
    return {
      kind: "web", key: "", glyph: "󰖟",
      title: q ? "Search the web for “" + _esc(q) + "”" : "Type to search the web",
      desc: Config.webSearchUrl.replace(/^https?:\/\//, "").split("/")[0],
      run: () => { if (q) Quickshell.execDetached(["xdg-open", Config.webSearchUrl + encodeURIComponent(q)]); }
    };
  }

  // ── Results ─────────────────────────────────────────────────────────
  readonly property var results: {
    const q = _fold(term);
    // Touch the inputs this depends on, so the binding re-evaluates.
    usage.items; calcResult; calcFor; calcError; emojis; ClipboardService.entries;

    switch (mode) {
    case "=": return calcExpr ? [_calcItem()]
                              : [{ kind: "hint", key: "", glyph: "󰃬", title: "Type an expression", desc: "2^10  ·  5 km to mi  ·  30 usd to brl  ·  sqrt(2)", run: () => {} }];
    case ":": return _emojiItems(q);
    case ";": return _clipItems(q);
    case "$": return _shellItems(term);
    case "?": return [_webItem(term)];
    case "/": {
      const out = [];
      actions.forEach((a, i) => {
        const s = q ? _fieldScore(_fold(a.name), q) : 0;
        if (s < 0) return;
        out.push({ item: _actionItem(a, q), i, s: s + Math.min(40, _frecency("action:" + a.id) * 8) });
      });
      // Index tie-break: QML's sort isn't stable.
      return out.sort((a, b) => b.s - a.s || a.i - b.i).map(o => o.item);
    }
    }

    // Apps (mode "" or ">").
    const scored = [];
    for (const e of apps) {
      let s = 0;
      if (q) { s = _appScore(e, q); if (s < 0) continue; }
      // Usage breaks ties and orders the empty list, capped so it never
      // lifts a weak match above a strong one.
      s += Math.min(60, _frecency("app:" + (e.id || e.name)) * 6);
      scored.push({ e, s });
    }
    scored.sort((a, b) => b.s !== a.s ? b.s - a.s : (a.e.name || "").localeCompare(b.e.name || ""));
    let out = scored.slice(0, mode === ">" || q ? _maxRows : 400).map(o => _appItem(o.e, q));
    if (mode === ">" || !q) return out;

    // Matching actions sit under strong app hits, maths on top, web last.
    const acts = [];
    if (q.length >= 2) {
      for (const a of actions) {
        const s = _fieldScore(_fold(a.name), q);
        if (s >= 600) acts.push(_actionItem(a, q));
      }
    }
    const strong = scored.filter(o => o.s >= 600).length;
    out = out.slice(0, strong).concat(acts, out.slice(strong));
    if (calcExpr) out.unshift(_calcItem());
    out.push(_webItem(term));
    return out;
  }

  readonly property var current: results[Math.max(0, Math.min(selectedIndex, results.length - 1))] ?? null

  // ── Behaviour ───────────────────────────────────────────────────────
  onVisibleChanged: {
    if (visible) {
      selectedIndex = 0;
      actionIndex = -1;
      _presented = true;
      searchField.forceActiveFocus();
    } else {
      _presented = false;
      mode = "";
      searchField.text = "";
    }
  }

  function _resetSelection() { selectedIndex = 0; actionIndex = -1; listView.positionViewAtBeginning(); }
  onQueryChanged: _resetSelection()
  onModeChanged: {
    _resetSelection();
    if (mode === ";" && !ClipboardService.loading) ClipboardService.refresh();
  }

  function moveSelection(delta) {
    if (results.length === 0) return;
    actionIndex = -1;
    selectedIndex = (selectedIndex + delta + results.length) % results.length;
    listView.positionViewAtIndex(selectedIndex, ListView.Contain);
  }

  function cycleAction(delta) {
    const n = Math.min(3, current?.actions?.length ?? 0);   // the row shows three
    if (n === 0) { moveSelection(delta); return; }
    actionIndex = ((actionIndex + 1 + delta) % (n + 1) + n + 1) % (n + 1) - 1;
  }

  function activate(i, alt) {
    const it = results[i];
    if (!it || it.kind === "hint") return;
    const ai = i === selectedIndex ? actionIndex : -1;
    _bump(it.key);
    // Drop our exclusive keyboard focus first so the new window (or the
    // wtype paste) lands in the right place.
    launcher.visible = false;
    it.run(alt, ai);
  }

  Timer {
    id: closeTimer
    interval: 1
    onTriggered: launcher.visible = false
  }

  // Click-outside catcher
  MouseArea {
    anchors.fill: parent
    onClicked: launcher.visible = false
  }

  // ── Card: flat against the top bar, unfurls downward ────────────────
  Item {
    id: assembly
    width: launcher._cardWidth + launcher._transitionSize * 2
    height: launcher._cardHeight + launcher._transitionSize
    x: (launcher.width - width) / 2
    y: launcher._topBarHeight

    opacity: launcher._presented ? 1 : 0
    Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }

    Item {
      id: card
      x: launcher._transitionSize
      width: launcher._cardWidth
      height: launcher._presented ? launcher._cardHeight : 0
      clip: true
      Behavior on height {
        Anim {
          curve: launcher._presented ? Motion.decel : Motion.accel
          duration: launcher._presented ? Motion.fastSpatialDuration : Motion.exitDuration
        }
      }

      Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: -launcher._cornerRadius }
        height: parent.height + launcher._cornerRadius
        radius: launcher._cornerRadius
        color: launcher._cardColor
      }

      // Eat clicks on the card so the outside catcher doesn't close us.
      MouseArea { anchors.fill: parent; onClicked: searchField.forceActiveFocus() }

      ColumnLayout {
        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 14; rightMargin: 14; topMargin: 14 }
        height: launcher._cardHeight - 22
        spacing: 10

        // ── Search bar ────────────────────────────────────────────────
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 46
          radius: 12
          color: Qt.rgba(1, 1, 1, 0.05)
          border.width: 1
          border.color: Qt.rgba(1, 1, 1, searchField.activeFocus ? 0.18 : 0.08)
          Behavior on border.color { CAnim {} }

          RowLayout {
            anchors { fill: parent; leftMargin: 12; rightMargin: 14 }
            spacing: 10

            // Mode chip, or the magnifier when searching apps.
            Rectangle {
              Layout.alignment: Qt.AlignVCenter
              implicitHeight: 28
              implicitWidth: launcher.mode ? chipRow.implicitWidth + 18 : 28
              radius: 14
              color: launcher.mode ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
              Behavior on implicitWidth { Anim { duration: Motion.fastSpatialDuration } }
              Behavior on color { CAnim {} }

              Row {
                id: chipRow
                anchors.centerIn: parent
                spacing: 6
                StyledText {
                  anchors.verticalCenter: parent.verticalCenter
                  text: launcher.mode ? launcher.modes[launcher.mode].glyph : "󰍉"
                  font.pixelSize: Config.fontSize + 2
                  color: launcher.mode ? launcher._hi : launcher._sub
                }
                StyledText {
                  anchors.verticalCenter: parent.verticalCenter
                  visible: launcher.mode !== ""
                  text: launcher.mode ? launcher.modes[launcher.mode].name : ""
                  font.pixelSize: Config.fontSize - 2
                  color: launcher._hi
                }
              }
            }

            TextInput {
              id: searchField
              Layout.fillWidth: true
              verticalAlignment: TextInput.AlignVCenter
              font.pixelSize: Config.fontSize + 1
              font.family: Config.fontFamily
              color: launcher._hi
              selectionColor: Qt.rgba(1, 1, 1, 0.25)
              selectByMouse: true
              clip: true
              focus: launcher.visible
              onTextChanged: {
                if (launcher.mode === "" && text.length > 0 && launcher.modes[text.charAt(0)]) {
                  launcher.mode = text.charAt(0);
                  text = text.slice(1);   // re-enters with the rest
                  return;
                }
                launcher.query = text;
              }

              Keys.onPressed: (event) => {
                const shift = (event.modifiers & Qt.ShiftModifier) !== 0;
                const ctrl = (event.modifiers & Qt.ControlModifier) !== 0;
                switch (event.key) {
                case Qt.Key_Down:     launcher.moveSelection(1); break;
                case Qt.Key_Up:       launcher.moveSelection(-1); break;
                case Qt.Key_PageDown: launcher.moveSelection(8); break;
                case Qt.Key_PageUp:   launcher.moveSelection(-8); break;
                case Qt.Key_Tab:      launcher.cycleAction(1); break;
                case Qt.Key_Backtab:  launcher.cycleAction(-1); break;
                case Qt.Key_Return:
                case Qt.Key_Enter:    launcher.activate(launcher.selectedIndex, shift); break;
                case Qt.Key_Escape:
                  // Esc clears the text, then the mode, then closes.
                  if (searchField.text.length > 0) searchField.text = "";
                  else if (launcher.mode) launcher.mode = "";
                  else launcher.visible = false;
                  break;
                case Qt.Key_J: if (ctrl) { launcher.moveSelection(1); break; } return;
                case Qt.Key_K: if (ctrl) { launcher.moveSelection(-1); break; } return;
                case Qt.Key_Backspace:
                  // Backspace on an empty field drops the mode chip.
                  if (launcher.mode && searchField.text.length === 0) { launcher.mode = ""; break; }
                  return;
                default: return;
                }
                event.accepted = true;
              }

              StyledText {
                visible: searchField.text.length === 0
                anchors.verticalCenter: parent.verticalCenter
                text: ({
                  "":  "Search apps, or type / = : ; $ ? for more",
                  ">": "Search apps…",
                  "/": "Search actions…",
                  "=": "2^10 · 5 km to mi · 30 usd to brl",
                  ":": "Search emoji…",
                  ";": "Search clipboard…",
                  "$": "Command to run…",
                  "?": "Search the web…"
                })[launcher.mode]
                font.pixelSize: Config.fontSize + 1
                color: launcher._dim
              }
            }

            StyledText {
              visible: launcher.results.length > 1 && (launcher.mode === "" || launcher.mode === ">" || launcher.mode === ":" || launcher.mode === ";")
              text: launcher.results.length
              font.pixelSize: Config.fontSize - 3
              color: launcher._dim
            }
          }
        }

        // ── Results ───────────────────────────────────────────────────
        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true
          clip: true

          ListView {
            id: listView
            anchors.fill: parent
            model: launcher.results
            spacing: 4
            boundsBehavior: Flickable.StopAtBounds
            cacheBuffer: 300
            highlightMoveDuration: 0

            delegate: LauncherRow {
              required property var modelData
              required property int index
              width: listView.width
              height: launcher._rowHeight
              item: modelData
              selected: index === launcher.selectedIndex
              actionIndex: selected ? launcher.actionIndex : -1
              onActivated: (alt) => { launcher.selectedIndex = index; launcher.activate(index, alt); }
              onActionClicked: (ai) => { launcher.selectedIndex = index; launcher.actionIndex = ai; launcher.activate(index, false); }
              onHovered: if (launcher.selectedIndex !== index) { launcher.selectedIndex = index; launcher.actionIndex = -1; }
            }

            ScrollBar.vertical: ScrollBar {
              policy: ScrollBar.AsNeeded
              width: 4
              contentItem: Rectangle { radius: 2; color: Qt.rgba(1, 1, 1, 0.15) }
            }
          }

          StyledText {
            visible: launcher.results.length === 0
            anchors.centerIn: parent
            text: launcher.mode === ";" ? (ClipboardService.loading ? "Loading…" : "Nothing in the clipboard history")
                : launcher.mode === ":" && launcher.emojis.length === 0 ? "Emoji table not found (rebuild)"
                : launcher.term.length > 0 ? "No matches" : "Loading…"
            font.pixelSize: Config.fontSize - 1
            color: launcher._dim
          }
        }

        // ── Footer: modes when idle, keys otherwise ───────────────────
        RowLayout {
          Layout.fillWidth: true
          Layout.preferredHeight: 22
          spacing: 14

          Repeater {
            model: launcher.query.length === 0 && !launcher.mode ? Object.keys(launcher.modes) : []
            delegate: Item {
              id: hint
              required property string modelData
              implicitWidth: hintRow.implicitWidth
              implicitHeight: hintRow.implicitHeight
              Row {
                id: hintRow
                spacing: 5
                StyledText {
                  text: hint.modelData
                  font.pixelSize: Config.fontSize - 2
                  font.weight: Font.Bold
                  color: launcher._fg
                }
                StyledText {
                  text: launcher.modes[hint.modelData].name.toLowerCase()
                  font.pixelSize: Config.fontSize - 3
                  color: launcher._dim
                }
              }
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: launcher.setQuery(hint.modelData)
              }
            }
          }

          StyledText {
            visible: launcher.query.length > 0 || launcher.mode !== ""
            text: {
              const it = launcher.current;
              const enter = { emoji: "↵ type", clip: "↵ paste", calc: "↵ copy", shell: "↵ run" }[it?.kind] ?? "↵ open";
              const parts = ["↑↓ select", enter];
              if (it?.actions?.length) parts.push("Tab actions");
              if (it?.kind === "emoji" || it?.kind === "clip") parts.push("⇧↵ copy only");
              if (it?.kind === "shell") parts.push("⇧↵ background");
              parts.push(launcher.query ? "Esc clear" : "⌫ leave mode");
              return parts.join("   ·   ");
            }
            font.pixelSize: Config.fontSize - 3
            color: launcher._dim
          }

          Item { Layout.fillWidth: true }
        }
      }
    }
  }

  // Rounded outer corners where the card meets the top bar.
  RoundCorner {
    x: (launcher.width - launcher._cardWidth) / 2 - launcher._cornerRadius
    y: launcher._topBarHeight
    implicitSize: launcher._cornerRadius
    corner: RoundCorner.CornerEnum.TopRight
    color: launcher._cardColor
    visible: assembly.opacity > 0.05
    opacity: assembly.opacity
  }

  RoundCorner {
    x: (launcher.width - launcher._cardWidth) / 2 + launcher._cardWidth
    y: launcher._topBarHeight
    implicitSize: launcher._cornerRadius
    corner: RoundCorner.CornerEnum.TopLeft
    color: launcher._cardColor
    visible: assembly.opacity > 0.05
    opacity: assembly.opacity
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void { launcher.visible = !launcher.visible; }
    function open(): void   { launcher.visible = true; }
    function close(): void  { launcher.visible = false; }
    // Open straight into a mode, e.g. `launcher openWith "="`.
    function openWith(prefix: string): void { launcher.openWith(prefix); }
  }
}
