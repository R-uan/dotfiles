import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Controls

// Clipboard history (cliphist). Type to filter · ↑↓ select ·
// Enter paste into the previous window · Shift+Enter copy only ·
// Delete remove · Esc close.
DockedPanel {
  id: clipMenu
  edge: "center"
  visible: false
  objectName: "Clipboard"
  cardWidth: 400
  cardHeight: 470
  modal: true
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

  property alias timer: closeTimer
  property int selectedIndex: 0
  property string query: ""

  readonly property color _fg:   Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _acc:  Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color _dim:  Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _mute: Config.darkMode ? ThemeDark.muted       : ThemeLight.muted

  readonly property var results: {
    const q = query.trim().toLowerCase();
    if (q.length === 0) return ClipboardService.entries;
    return ClipboardService.entries.filter(e =>
      e.isImage ? "image".includes(q) || e.format.includes(q) : e.text.toLowerCase().includes(q));
  }

  onVisibleChanged: {
    if (visible) {
      ClipboardService.refresh();
      search.text = "";
      selectedIndex = 0;
      search.forceActiveFocus();
    }
  }

  onResultsChanged: selectedIndex = Math.min(selectedIndex, Math.max(0, results.length - 1))

  function choose(paste) {
    const e = results[selectedIndex];
    if (!e) return;
    clipMenu.visible = false;
    ClipboardService.copy(e, paste);
  }

  Timer {
    id: closeTimer
    interval: 1000
    onTriggered: clipMenu.visible = false
  }

  ColumnLayout {
    x: 14
    y: 14
    width: parent.width - 28
    height: parent.height - 28
    spacing: 10

    // ── Header ────────────────────────────────────────────
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      StyledText {
        text: "󰅌"
        font.pixelSize: Config.fontSize + 4
        color: clipMenu._acc
      }
      StyledText {
        Layout.fillWidth: true
        text: "Clipboard"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: clipMenu._fg
      }
      StyledText {
        text: ClipboardService.entries.length + " items"
        font.pixelSize: Config.fontSize - 4
        color: clipMenu._dim
      }
      Rectangle {
        implicitWidth: wipeText.implicitWidth + 14
        implicitHeight: 22
        radius: 6
        visible: ClipboardService.entries.length > 0
        color: wipeMa.containsMouse
          ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
          : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04))
        Behavior on color { CAnim {} }
        StyledText {
          id: wipeText
          anchors.centerIn: parent
          text: "Clear"
          font.pixelSize: Config.fontSize - 4
          color: clipMenu._fg
        }
        MouseArea {
          id: wipeMa
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: ClipboardService.wipe()
        }
      }
    }

    // ── Search ────────────────────────────────────────────
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 32
      radius: 8
      color: Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04)
      border.width: 1
      border.color: Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.10)

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8

        StyledText {
          text: "󰍉"
          font.pixelSize: Config.fontSize - 1
          color: clipMenu._dim
        }

        TextInput {
          id: search
          Layout.fillWidth: true
          verticalAlignment: TextInput.AlignVCenter
          font.family: Config.fontFamily
          font.pixelSize: Config.fontSize - 2
          color: clipMenu._fg
          clip: true
          onTextChanged: { clipMenu.query = text; clipMenu.selectedIndex = 0; }

          Keys.onPressed: (event) => {
            const n = clipMenu.results.length;
            if (event.key === Qt.Key_Escape) {
              clipMenu.visible = false;
            } else if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && event.modifiers & Qt.ControlModifier)) {
              clipMenu.selectedIndex = Math.min(n - 1, clipMenu.selectedIndex + 1);
            } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && event.modifiers & Qt.ControlModifier)) {
              clipMenu.selectedIndex = Math.max(0, clipMenu.selectedIndex - 1);
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              clipMenu.choose(!(event.modifiers & Qt.ShiftModifier));
            } else if (event.key === Qt.Key_Delete) {
              const e = clipMenu.results[clipMenu.selectedIndex];
              if (e) ClipboardService.remove(e);
            } else {
              return;
            }
            event.accepted = true;
            list.positionViewAtIndex(clipMenu.selectedIndex, ListView.Contain);
          }

          StyledText {
            visible: search.text.length === 0
            anchors.verticalCenter: parent.verticalCenter
            text: "search…"
            font.pixelSize: Config.fontSize - 2
            color: clipMenu._dim
          }
        }
      }
    }

    // ── Entries ───────────────────────────────────────────
    ListView {
      id: list
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      spacing: 4
      model: clipMenu.results
      boundsBehavior: Flickable.StopAtBounds
      highlightMoveDuration: 0
      currentIndex: clipMenu.selectedIndex

      ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        width: 5
        visible: list.contentHeight > list.height
        contentItem: Rectangle {
          radius: 3
          color: Config.darkMode ? Qt.rgba(1,1,1,0.20) : Qt.rgba(0,0,0,0.20)
        }
      }

      delegate: Item {
        id: row
        required property var modelData
        required property int index
        readonly property bool _sel: index === clipMenu.selectedIndex
        width: list.width - 8
        height: modelData.isImage ? 84 : Math.max(38, textItem.implicitHeight + 18)

        Rectangle {
          anchors.fill: parent
          radius: 8
          color: row._sel
            ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.09))
            : (rowMa.containsMouse ? (Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.04)) : "transparent")
          Behavior on color { CAnim {} }
        }

        StyledText {
          id: textItem
          visible: !row.modelData.isImage
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          anchors.leftMargin: 10
          anchors.rightMargin: 10
          text: row.modelData.text.replace(/\s+/g, " ").trim()
          wrapMode: Text.WrapAnywhere
          maximumLineCount: 2
          elide: Text.ElideRight
          font.pixelSize: Config.fontSize - 2
          color: row._sel ? clipMenu._fg : clipMenu._acc
        }

        // Image entry: decoded once into the cache, then shown as a thumb.
        Row {
          visible: row.modelData.isImage
          anchors.left: parent.left
          anchors.leftMargin: 10
          anchors.verticalCenter: parent.verticalCenter
          spacing: 10

          Rectangle {
            width: 112
            height: 64
            radius: 6
            color: Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.05)
            clip: true

            Image {
              id: thumb
              anchors.fill: parent
              fillMode: Image.PreserveAspectCrop
              asynchronous: true
              sourceSize.width: 224
              cache: false
            }
          }
          StyledText {
            anchors.verticalCenter: parent.verticalCenter
            text: row.modelData.format.toUpperCase() + "\n" + row.modelData.w + "×" + row.modelData.h
            font.pixelSize: Config.fontSize - 4
            color: clipMenu._dim
          }
        }

        Process {
          id: decodeProc
          property string target: row.modelData.isImage ? ClipboardService.imagePath(row.modelData) : ""
          command: ["sh", "-c", 'mkdir -p "$(dirname "$2")"; [ -s "$2" ] || printf "%s" "$1" | cliphist decode > "$2"',
                    "sh", row.modelData.line, target]
          onExited: thumb.source = "file://" + target
        }
        Component.onCompleted: if (row.modelData.isImage) decodeProc.running = true

        MouseArea {
          id: rowMa
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          acceptedButtons: Qt.LeftButton | Qt.MiddleButton
          onClicked: (mouse) => {
            clipMenu.selectedIndex = row.index;
            if (mouse.button === Qt.MiddleButton) ClipboardService.remove(row.modelData);
            else clipMenu.choose(true);
          }
        }
      }

      StyledText {
        anchors.centerIn: parent
        visible: clipMenu.results.length === 0
        text: ClipboardService.loading ? "Loading…"
            : clipMenu.query.length > 0 ? "No matches" : "Clipboard history is empty"
        font.pixelSize: Config.fontSize - 2
        color: clipMenu._mute
      }
    }

    StyledText {
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      text: "enter paste · shift+enter copy · del remove · esc close"
      font.pixelSize: Config.fontSize - 6
      font.letterSpacing: 0.8
      color: clipMenu._mute
    }
  }

  IpcHandler {
    target: "clipboard"
    function toggle(): void { clipMenu.visible = !clipMenu.visible; }
    function open(): void   { clipMenu.visible = true; }
  }
}
