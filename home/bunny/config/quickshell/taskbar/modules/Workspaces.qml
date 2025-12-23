import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs
import qs.taskbar
import qs.taskbar.shared
import qs.taskbar.services

Item {
  id: root
  height: parent.height
  width: layout.implicitWidth + 10

  Row {
    id: layout
    spacing: 12
    anchors.centerIn: parent

    Repeater {
      id: workspaces
      model: {
        let workspaceList = Hyprland.workspaces.values || [];
        let minWorkspaces = 6;
        let result = [];

        if (workspaceList.length === 0) {
          // No workspaces, create 6 placeholders
          for (let i = 1; i <= minWorkspaces; i++) {
            result.push({
                          id: i,
                          isDummy: true,
                          activate: function () {
                            Hyprland.dispatch(`workspace ${i}`);
                          }
                        });
          }
          return result;
        }

        // Sort by id
        let sorted = workspaceList.slice().sort((a, b) => a.id - b.id);

        // Find the max id
        let maxId = Math.max(...sorted.map(ws => ws.id), minWorkspaces);

        // Fill in gaps
        for (let i = 1; i <= maxId; i++) {
          let existing = sorted.find(ws => ws.id === i);
          if (existing) {
            result.push(existing);
          } else {
            // Create dummy workspace for missing id
            result.push({
                          id: i,
                          isDummy: true,
                          activate: function () {
                            Hyprland.dispatch(`workspace ${i}`);
                          }
                        });
          }
        }

        return result;
      }

      delegate: Rectangle {
        id: wsBox
        radius: 60
        // topLeftRadius: Theme.radius - 12
        // topRightRadius: Theme.radius - 12
        // bottomLeftRadius: Theme.radius - 7
        // bottomRightRadius: Theme.radius - 7

        width: 12
        height: 12
        color: modelData.active ? Theme.primary :
               modelData.urgent ? Theme.rose :
               modelData.isDummy ? 
                hover.containsMouse ? Theme.lpurpleAlt : Theme.purpleAlt : // Dummy
                hover.containsMouse ? Theme.lgreenAlt : Theme.greenAlt     // Active

        Behavior on width {
          NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
          }
        }

        MouseArea {
          id: hover
          anchors.fill: parent
          hoverEnabled: true
          onClicked: if (mouse.button === Qt.LeftButton)
                       modelData.activate()
        }
      }
    }
  }
}
