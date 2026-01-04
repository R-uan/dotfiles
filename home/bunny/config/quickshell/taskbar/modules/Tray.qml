pragma ComponentBehavior: Bound

import QtQuick
import qs.shared
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
  id: root
  clip: true
  visible: {
    items.count > 0;
  }
  implicitHeight: parent.height
  implicitWidth: layout.width + 16

  Row {
    id: layout
    spacing: 3
    anchors.centerIn: root
    layoutDirection: Qt.RightToLeft

    Repeater {
      id: items
      model: SystemTray.items
      delegate: MouseArea {
        id: trayItem
        implicitWidth: Theme.fontSize * 1.09
        implicitHeight: Theme.fontSize * 1.09
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        required property SystemTrayItem modelData

        onClicked: event => {
          if (event.button === Qt.LeftButton)
          modelData.activate();
          else {
            if (modelData.hasMenu) {
              const pos = mapToItem(mainWindow.contentItem, 0, height + 10);
              console.log(mainWindow);
              modelData.display(popup, pos.x, pos.y);
            }
          }
        }

        PopupWindow {
          id: popup
          anchor.window: mainWindow
        }

        IconImage {
          asynchronous: true
          anchors.fill: parent

          source: {
            let icon = trayItem.modelData.icon;
            if (icon.includes("?path=")) {
              const [name, path] = icon.split("?path=");
              icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
          }
        }
      }
    }
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: 1
      easing.bezierCurve: 2
      easing.type: Easing.BezierSpline
    }
  }

  Behavior on implicitHeight {
    NumberAnimation {
      duration: 1
      easing.bezierCurve: 2
      easing.type: Easing.BezierSpline
    }
  }
}
