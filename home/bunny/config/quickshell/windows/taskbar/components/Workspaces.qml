import qs.shared
import qs.config

import QtQuick
import Quickshell.Hyprland

Item {
  id: root
  height: parent.height
  width: layout.implicitWidth + 20

  ListModel {
    id: workspaceModel
  }

  Component.onCompleted: {
    updateWorkspaceModel();
  }

  Connections {
    target: Hyprland.workspaces
    function onValuesChanged() {
      // Use a small delay to let the active property update
      updateTimer.restart();
    }
  }

  // Watch for active property changes on individual workspaces
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

  // Timer to delay updates slightly so active property can update
  Timer {
    id: updateTimer
    interval: 50
    repeat: false
    onTriggered: updateWorkspaceModel()
  }

  // Also try connecting to activeWorkspace property directly
  property int activeWorkspaceId: Hyprland.activeWorkspace ? Hyprland.activeWorkspace.id : -1

  onActiveWorkspaceIdChanged: {
    updateWorkspaceModel();
  }

  function updateWorkspaceModel() {
    let workspaceList = Hyprland.workspaces.values || [];
    let minWorkspaces = 6;
    let targetWorkspaces = [];

    // Debug logging
    if (workspaceList.length > 0) {
      let ws = workspaceList[0];
    }

    // Find active workspace from the list
    let activeWorkspace = workspaceList.find(ws => ws.active);
    let activeId = activeWorkspace ? activeWorkspace.id : -1;

    if (workspaceList.length === 0) {
      // No workspaces, create 6 placeholders
      for (let i = 1; i <= minWorkspaces; i++) {
        targetWorkspaces.push({
                                workspaceId: i,
                                isDummy: true,
                                active: i === activeId  // Check if this is the active workspace
                                        ,
                                urgent: false
                              });
      }
    } else {
      // Sort by id
      let sorted = workspaceList.slice().sort((a, b) => a.id - b.id);

      // Find the max id
      let maxId = Math.max(...sorted.map(ws => ws.id), minWorkspaces);

      // Fill in gaps
      for (let i = 1; i <= maxId; i++) {
        let existing = sorted.find(ws => ws.id === i);
        if (existing) {
          targetWorkspaces.push({
                                  workspaceId: existing.id,
                                  isDummy: false,
                                  active: existing.id
                                          === activeId  // Always use activeId, not existing.active
                                          ,
                                  urgent: existing.urgent || false
                                });
        } else {
          // Create dummy workspace for missing id
          targetWorkspaces.push({
                                  workspaceId: i,
                                  isDummy: true,
                                  active: i === activeId  // Check if this is the active workspace
                                          ,
                                  urgent: false
                                });
        }
      }
    }

    // Update existing items or add/remove as needed
    for (let i = 0; i < targetWorkspaces.length; i++) {
      if (i < workspaceModel.count) {
        // Update existing item
        workspaceModel.set(i, targetWorkspaces[i]);
      } else {
        // Append new item
        workspaceModel.append(targetWorkspaces[i]);
      }
    }

    // Remove excess items
    while (workspaceModel.count > targetWorkspaces.length) {
      workspaceModel.remove(workspaceModel.count - 1);
    }
  }

  Row {
    id: layout
    spacing: Theme.spacing + 5
    anchors.centerIn: parent

    Repeater {
      id: workspaces
      model: workspaceModel

      delegate: Rectangle {
        id: wsBox
        radius: 3
        height: 12
        width: model.active ? 24 : 12
        color: {
          if (model.active)
            return Theme.primary;
          if (model.urgent)
            return Theme.rose;
          if (model.isDummy) {
            return hover.containsMouse ? Theme.secondaryHover : Theme.secondary;
          }
          return hover.containsMouse ? Theme.primaryHover : Theme.tertiary;
        }

        Behavior on width {
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
