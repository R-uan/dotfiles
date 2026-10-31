import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick.Effects

// Workspace column, after caelestia / end-4:
//  - runs of occupied workspaces merge into one rounded track
//  - the active pill stretches toward its target, then the tail catches up
//  - occupied workspaces show a grayscale icon of their window, empty
//    ones a dot
Item {
  id: root
  // Must be implicit: this sits inside a ColumnLayout, and an explicit height
  // leaves the layout stuck at whatever it first measured while the Column
  // keeps growing. Dots spilling past the section's bounds render but stop
  // receiving pointer events, so anything past the 6th became unclickable.
  implicitWidth: parent ? parent.width : 0
  implicitHeight: layout.implicitHeight + 10

  readonly property int cell: 28
  readonly property int iconSize: 16

  ListModel {
    id: workspaceModel
  }

  Component.onCompleted: {
    updateWorkspaceModel();
  }

  Connections {
    target: Hyprland.workspaces
    function onValuesChanged() {
      updateTimer.restart();
    }
  }

  Repeater {
    model: Hyprland.workspaces.values || []
    Item {
      Connections {
        target: modelData
        function onActiveChanged() {
          updateTimer.restart();
        }
      }
    }
  }

  Timer {
    id: updateTimer
    interval: 50
    repeat: false
    onTriggered: updateWorkspaceModel()
  }

  property int activeWorkspaceId: Hyprland.activeWorkspace ? Hyprland.activeWorkspace.id : -1

  onActiveWorkspaceIdChanged: {
    updateWorkspaceModel();
  }

  // Workspace id -> toplevels on it. A binding, so it follows windows
  // opening, closing and moving without touching the model.
  readonly property var windowsById: {
    const out = {};
    for (const ws of Hyprland.workspaces.values || [])
      out[ws.id] = ws.toplevels ? ws.toplevels.values : [];
    return out;
  }

  function occupied(id) {
    const tops = root.windowsById[id];
    return !!tops && tops.length > 0;
  }

  function updateWorkspaceModel() {
    let workspaceList = Hyprland.workspaces.values || [];
    let minWorkspaces = 6;
    let targetWorkspaces = [];

    let activeWorkspace = workspaceList.find(ws => ws.active);
    let activeId = activeWorkspace ? activeWorkspace.id : -1;

    let sorted = workspaceList.filter(ws => ws.id > 0).sort((a, b) => a.id - b.id);
    let maxId = Math.max(minWorkspaces, ...sorted.map(ws => ws.id));

    for (let i = 1; i <= maxId; i++) {
      let existing = sorted.find(ws => ws.id === i);
      targetWorkspaces.push({
        workspaceId: i,
        isDummy: !existing,
        active: i === activeId,
        urgent: existing ? (existing.urgent || false) : false
      });
    }

    for (let i = 0; i < targetWorkspaces.length; i++) {
      if (i < workspaceModel.count) {
        workspaceModel.set(i, targetWorkspaces[i]);
      } else {
        workspaceModel.append(targetWorkspaces[i]);
      }
    }

    while (workspaceModel.count > targetWorkspaces.length) {
      workspaceModel.remove(workspaceModel.count - 1);
    }

    root.moveIndicator(activeId - 1);
  }

  // ── Active indicator with a trailing end ───────────────────────
  property real indStart: 0
  property real indEnd: cell
  property bool _goingUp: false

  function moveIndicator(index) {
    if (index < 0) return;
    const start = index * root.cell;
    root._goingUp = start < root.indStart;
    root.indStart = start;
    root.indEnd = start + root.cell;
  }

  Behavior on indStart {
    Anim {
      duration: root._goingUp ? Motion.fastSpatialDuration : Motion.fastSpatialDuration * 1.5
    }
  }
  Behavior on indEnd {
    Anim {
      duration: root._goingUp ? Motion.fastSpatialDuration * 1.5 : Motion.fastSpatialDuration
    }
  }

  // Scroll over the strip to step through workspaces, same as SUPER+wheel.
  // Accumulated so a touchpad swipe moves one workspace, not several.
  property real _wheelAcc: 0
  WheelHandler {
    onWheel: (event) => {
      root._wheelAcc += event.angleDelta.y;
      if (root._wheelAcc >= 120) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "e-1" })`);
        root._wheelAcc = 0;
      } else if (root._wheelAcc <= -120) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "e+1" })`);
        root._wheelAcc = 0;
      }
    }
  }

  Item {
    id: layout
    anchors.centerIn: parent
    implicitWidth: root.cell
    implicitHeight: column.implicitHeight

    // Occupied track, drawn per cell. A cell squares off the side it shares
    // with an occupied neighbour, so a run reads as one rounded shape.
    Column {
      anchors.fill: parent

      Repeater {
        model: workspaceModel

        delegate: Rectangle {
          required property int workspaceId
          readonly property bool _occ: root.occupied(workspaceId)
          readonly property bool _prev: _occ && root.occupied(workspaceId - 1)
          readonly property bool _next: _occ && root.occupied(workspaceId + 1)

          width: root.cell
          height: root.cell
          color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.07)
          opacity: _occ ? 1 : 0
          topLeftRadius: _prev ? 0 : root.cell / 2
          topRightRadius: topLeftRadius
          bottomLeftRadius: _next ? 0 : root.cell / 2
          bottomRightRadius: bottomLeftRadius

          Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
          Behavior on topLeftRadius { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
          Behavior on bottomLeftRadius { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
        }
      }
    }

    Rectangle {
      id: indicator
      x: 0
      y: root.indStart
      width: root.cell
      height: root.indEnd - root.indStart
      radius: root.cell / 2
      color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.17) : Qt.rgba(0, 0, 0, 0.16)
      border.width: 1
      border.color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.10)
    }

    Column {
      id: column

      Repeater {
        id: workspaces
        model: workspaceModel

        delegate: Item {
          id: wsBox
          required property int workspaceId
          required property bool active
          required property bool urgent

          readonly property var _tops: root.windowsById[workspaceId] || []
          readonly property bool _occ: _tops.length > 0
          // Prefer the Wayland app id; fall back to Hyprland's window class.
          readonly property string _appId: _occ
            ? (_tops[0].wayland?.appId || _tops[0].lastIpcObject?.class || "")
            : ""
          readonly property string _iconSource: AppIcons.source(_appId)

          readonly property color _fg: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
          readonly property color _dim: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
          readonly property color _err: Config.darkMode ? ThemeDark.error : ThemeLight.error

          width: root.cell
          height: root.cell

          // Hover ring
          Rectangle {
            anchors.centerIn: parent
            width: root.cell - 4
            height: width
            radius: width / 2
            color: "transparent"
            border.width: 1
            border.color: Config.darkMode ? Qt.rgba(1, 1, 1, 0.22) : Qt.rgba(0, 0, 0, 0.20)
            opacity: hover.containsMouse && !wsBox.active ? 1 : 0
            Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
          }

          // Empty workspace: a dot
          Rectangle {
            anchors.centerIn: parent
            visible: !wsBox._occ
            width: wsBox.active ? 7 : 5
            height: width
            radius: width / 2
            color: wsBox.urgent ? wsBox._err : (wsBox.active ? wsBox._fg : wsBox._dim)
            Behavior on width { Anim { duration: Motion.fastSpatialDuration } }
            Behavior on color { CAnim {} }
          }

          // Occupied: grayscale app icon (glyph if no desktop entry matched)
          IconImage {
            id: appIcon
            anchors.centerIn: parent
            width: root.iconSize
            height: root.iconSize
            asynchronous: true
            source: wsBox._iconSource
            visible: false
          }

          MultiEffect {
            anchors.fill: appIcon
            source: appIcon
            visible: wsBox._occ && wsBox._iconSource.length > 0
            saturation: -1
            opacity: wsBox.active || wsBox.urgent || hover.containsMouse ? 1 : 0.55
            scale: hover.pressed ? 0.85 : 1
            Behavior on opacity { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
            Behavior on scale { Anim { duration: Motion.fastSpatialDuration } }
          }

          StyledText {
            anchors.centerIn: parent
            visible: wsBox._occ && wsBox._iconSource.length === 0
            text: "󰖯"
            font.pixelSize: 13
            color: wsBox.urgent ? wsBox._err : (wsBox.active ? wsBox._fg : wsBox._dim)
            Behavior on color { CAnim {} }
          }

          MouseArea {
            id: hover
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${wsBox.workspaceId} })`)
          }
        }
      }
    }
  }
}
