import qs.shared
import qs.config

import QtQuick
import Quickshell.Hyprland

Item {
  id: root
  width: parent.width
  height: layout.implicitHeight + 10
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

  function updateWorkspaceModel() {
    let workspaceList = Hyprland.workspaces.values || [];
    let minWorkspaces = 6;
    let targetWorkspaces = [];

    let activeWorkspace = workspaceList.find(ws => ws.active);
    let activeId = activeWorkspace ? activeWorkspace.id : -1;

    if (workspaceList.length === 0) {
      for (let i = 1; i <= minWorkspaces; i++) {
        targetWorkspaces.push({
          workspaceId: i,
          isDummy: true,
          active: i === activeId,
          urgent: false
        });
      }
    } else {
      let sorted = workspaceList.slice().sort((a, b) => a.id - b.id);
      let maxId = Math.max(...sorted.map(ws => ws.id), minWorkspaces);

      for (let i = 1; i <= maxId; i++) {
        let existing = sorted.find(ws => ws.id === i);
        if (existing) {
          targetWorkspaces.push({
            workspaceId: existing.id,
            isDummy: false,
            active: existing.id === activeId,
            urgent: existing.urgent || false
          });
        } else {
          targetWorkspaces.push({
            workspaceId: i,
            isDummy: true,
            active: i === activeId,
            urgent: false
          });
        }
      }
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
  }

  Column {
    id: layout
    spacing: Config.spacing + 5
    anchors.centerIn: parent

    Repeater {
      id: workspaces
      model: workspaceModel

      delegate: Rectangle {
        id: wsBox
        radius: 3
        width: 16
        height: model.active ? 32 : 16

        // Resolved theme properties
        readonly property color colPrimary0:      Config.darkMode ? ThemeDark.primary0      : ThemeLight.primary0
        readonly property color colPrimary1:      Config.darkMode ? ThemeDark.primary1      : ThemeLight.primary1
        readonly property color colPrimary2:      Config.darkMode ? ThemeDark.primary2      : ThemeLight.primary2
        readonly property color colPrimary0Hover: Config.darkMode ? ThemeDark.primary0Hover : ThemeLight.primary0Hover
        readonly property color colPrimary2Hover: Config.darkMode ? ThemeDark.primary2Hover : ThemeLight.primary2Hover
        readonly property color colError:         Config.darkMode ? ThemeDark.error         : ThemeLight.error

        color: {
          if (model.active)
            return colPrimary0;
          if (model.urgent)
            return colError;
          if (model.isDummy)
            return hover.containsMouse ? colPrimary2Hover : colPrimary2;
          return hover.containsMouse ? colPrimary0Hover : colPrimary1;
        }

        Behavior on height {
          NumberAnimation {
            duration: 70
            easing.type: Easing.InOutQuad
          }
        }

        Behavior on color {
          ColorAnimation {
            duration: 70
            easing.type: Easing.InOutQuad
          }
        }

        MouseArea {
          id: hover
          hoverEnabled: true
          anchors.fill: parent
          onClicked: {
            if (mouse.button === Qt.LeftButton) {
              Hyprland.dispatch(`workspace ${model.workspaceId}`);
            }
          }
        }
      }
    }
  }
}
