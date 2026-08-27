import qs.shared
import qs.config

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: launcher
  visible: false
  color: "transparent"
  objectName: "App Launcher"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  anchors { top: true; left: true; right: true; bottom: true }

  readonly property int _topBarHeight: 7
  readonly property int _transitionSize: 16
  readonly property int _cornerRadius: 16
  readonly property int _cardWidth: 780
  readonly property int _cardHeight: 520
  readonly property int _rowHeight: 52

  property alias timer: closeTimer
  property int selectedIndex: 0
  property string query: ""
  property var recency: ({})
  property bool _presented: false
  readonly property color _cardColor: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0

  // Score one text field against the query. Ordered so that a literal
  // substring always outranks a scattered subsequence — the old version only
  // did subsequence matching, so typing "code" ranked anything containing
  // c…o…d…e above the app actually named Code.
  function _fieldScore(s, q) {
    if (!s || s.length === 0) return -1;
    const trail = Math.min(60, Math.max(0, s.length - q.length));

    if (s === q) return 1000;
    if (s.startsWith(q)) return 800 - trail;

    // Start of any word: "code" -> "Visual Studio Code".
    if (s.indexOf(" " + q) >= 0) return 650 - trail;

    // Initials: "vsc" -> "Visual Studio Code".
    const initials = s.split(/[\s\-_.]+/)
                      .filter(w => w.length > 0)
                      .map(w => w.charAt(0))
                      .join("");
    if (q.length > 1 && initials.startsWith(q)) return 600;

    if (s.indexOf(q) >= 0) return 500 - trail;

    // Loose subsequence, kept only as a last resort and penalised by how far
    // the matched characters are spread apart.
    let i = 0, j = 0, first = -1, last = -1;
    while (i < s.length && j < q.length) {
      if (s.charAt(i) === q.charAt(j)) {
        if (first < 0) first = i;
        last = i;
        j++;
      }
      i++;
    }
    if (j !== q.length) return -1;
    return 300 - Math.min(250, last - first);
  }

  // Name is the primary field; generic name and desktop id can still match
  // but are ranked below any name hit.
  function _score(entry, q) {
    let best = _fieldScore((entry.name || "").toLowerCase(), q);
    const g = _fieldScore((entry.genericName || "").toLowerCase(), q);
    if (g >= 0) best = Math.max(best, g - 250);
    const i = _fieldScore((entry.id || "").toLowerCase(), q);
    if (i >= 0) best = Math.max(best, i - 150);
    return best;
  }

  readonly property var apps: {
    const raw = DesktopEntries.applications.values || [];
    return raw.filter(e => e && !e.noDisplay);
  }

  readonly property var results: {
    const q = query.trim().toLowerCase();
    const scored = [];
    for (const e of apps) {
      let score = 0;
      if (q.length > 0) {
        score = _score(e, q);
        if (score < 0) continue;
      }
      // Recency breaks ties and orders the unfiltered list, but is capped so
      // it can never lift a weak match above a strong one.
      score += Math.min(40, (recency[e.id || e.name] || 0) * 8);
      scored.push({ entry: e, score });
    }
    scored.sort((a, b) => {
      if (b.score !== a.score) return b.score - a.score;
      return (a.entry.name || "").localeCompare(b.entry.name || "");
    });
    return scored.map(x => x.entry);
  }

  onVisibleChanged: {
    if (visible) {
      query = "";
      selectedIndex = 0;
      searchField.text = "";
      searchField.forceActiveFocus();
      _presented = true;
    } else {
      _presented = false;
    }
  }

  onQueryChanged: selectedIndex = 0

  function moveSelection(delta) {
    if (results.length === 0) return;
    let n = selectedIndex + delta;
    if (n < 0) n = results.length - 1;
    if (n >= results.length) n = 0;
    selectedIndex = n;
    ensureVisible();
  }

  function ensureVisible() {
    // Must match the delegate: LauncherRow is _rowHeight tall, plus ListView
    // spacing. The old constant was 60 against a 56px row, so the highlighted
    // entry drifted out of view and Enter appeared to launch the wrong app.
    const rowH = _rowHeight + listView.spacing;
    const y = selectedIndex * rowH;
    if (y < listView.contentY) listView.contentY = y;
    else if (y + rowH > listView.contentY + listView.height)
      listView.contentY = y + rowH - listView.height;
  }

  // Quickshell's DesktopEntry.execute() runs the command headless and ignores
  // Terminal=true, so entries like nvim or htop would "launch" with no visible
  // window. Wrap those in the configured terminal emulator instead.
  function launchEntry(e) {
    if (e.runInTerminal) {
      const cmd = e.command || [];
      if (cmd.length > 0) {
        Quickshell.execDetached(Config.terminalCommand.concat(Array.prototype.slice.call(cmd)));
        return;
      }
    }
    e.execute();
  }

  function launchSelected() {
    if (results.length === 0) return;
    const i = Math.max(0, Math.min(selectedIndex, results.length - 1));
    const e = results[i];
    if (!e) return;
    const key = e.id || e.name;
    const next = Object.assign({}, recency);
    next[key] = (next[key] || 0) + 1;
    recency = next;
    // Drop our exclusive keyboard focus before spawning, so the new window
    // can take focus as it maps.
    launcher.visible = false;
    launchEntry(e);
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

  // ── Assembly: card body + top junction transitions ──────────
  // Card is centered horizontally, sits under the top bar, unfurls downward.
  Item {
    id: assembly
    width: launcher._cardWidth + launcher._transitionSize * 2
    height: launcher._cardHeight + launcher._transitionSize
    x: (launcher.width - width) / 2
    y: launcher._topBarHeight

    opacity: launcher._presented ? 1 : 0
    Behavior on opacity {
      NumberAnimation { duration: 200 }
    }

    // Card body — square top corners (flat against the top bar), rounded
    // bottom corners. Uses a taller inner rectangle inside a clip:true item
    // so the top rounded corners are cropped away.
    Item {
      id: card
      x: launcher._transitionSize
      y: 0
      width: launcher._cardWidth
      height: launcher._presented ? launcher._cardHeight : 0
      clip: true
      Behavior on height {
        NumberAnimation { duration: 260; easing.type: Easing.OutCubic }
      }

      Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: -launcher._cornerRadius
        height: parent.height + launcher._cornerRadius
        radius: launcher._cornerRadius
        color: launcher._cardColor
      }

      // Eat clicks on empty card area so outside catcher doesn't dismiss us.
      MouseArea { anchors.fill: parent; onClicked: {} }

      // Content — pinned to top, doesn't stretch during animation.
      ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        anchors.topMargin: 14
        height: launcher._cardHeight - 28
        spacing: 10

        // Search bar
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 44
          radius: 10
          color: Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.05)
          border.color: searchField.activeFocus
            ? (Config.darkMode ? Qt.rgba(1,1,1,0.20) : Qt.rgba(0,0,0,0.20))
            : (Config.darkMode ? Qt.rgba(1,1,1,0.08) : Qt.rgba(0,0,0,0.08))
          border.width: 1

          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 10

            StyledText {
              text: "󰍉"
              font.pixelSize: Config.fontSize + 2
              color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
            }

            TextInput {
              id: searchField
              Layout.fillWidth: true
              verticalAlignment: TextInput.AlignVCenter
              font.pixelSize: Config.fontSize + 1
              font.family: Config.fontFamily
              color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
              selectByMouse: true
              clip: true
              focus: launcher.visible
              onTextChanged: launcher.query = text
              Keys.onDownPressed:   launcher.moveSelection(1)
              Keys.onUpPressed:     launcher.moveSelection(-1)
              Keys.onReturnPressed: launcher.launchSelected()
              Keys.onEnterPressed:  launcher.launchSelected()
              Keys.onEscapePressed: launcher.visible = false
              Keys.onTabPressed:    launcher.moveSelection(1)

              StyledText {
                visible: searchField.text.length === 0
                anchors.verticalCenter: parent.verticalCenter
                text: "Search apps…"
                font.pixelSize: Config.fontSize + 1
                color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
              }
            }

            StyledText {
              visible: launcher.results.length > 0
              text: launcher.results.length + (launcher.query.length > 0 ? "" : " apps")
              font.pixelSize: Config.fontSize - 3
              color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
            }
          }
        }

        // Results list
        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          radius: 10
          color: "transparent"
          clip: true

          ListView {
            id: listView
            anchors.fill: parent
            model: launcher.results
            spacing: 4
            boundsBehavior: Flickable.StopAtBounds
            reuseItems: true
            cacheBuffer: 300

            delegate: LauncherRow {
              width: listView.width
              height: launcher._rowHeight
              entry: modelData
              selected: index === launcher.selectedIndex
              onActivated: {
                launcher.selectedIndex = index;
                launcher.launchSelected();
              }
            }

            ScrollBar.vertical: ScrollBar {
              policy: ScrollBar.AsNeeded
              width: 4
              contentItem: Rectangle {
                radius: 2
                color: Config.darkMode ? Qt.rgba(1,1,1,0.15) : Qt.rgba(0,0,0,0.15)
              }
            }
          }

          StyledText {
            visible: launcher.results.length === 0
            anchors.centerIn: parent
            text: launcher.query.length > 0 ? "No matches" : "Loading…"
            font.pixelSize: Config.fontSize - 1
            color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
          }
        }
      }
    }

  }

  // ── Rounded outer corners at the launcher/top-bar junctions ────
  // Same pattern the taskbar uses at its screen corners: a RoundCorner
  // filled with the card color, positioned just outside the card's top
  // corner. It extends the filled area into the wallpaper with a curved
  // edge, so the L-junction with the top bar reads as a rounded outer
  // convex corner instead of a sharp reflex angle.
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
    function toggle() { launcher.visible = !launcher.visible; }
    function open()   { launcher.visible = true; }
    function close()  { launcher.visible = false; }
  }
}
