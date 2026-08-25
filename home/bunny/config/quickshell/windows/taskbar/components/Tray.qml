pragma ComponentBehavior: Bound
import qs.shared
import qs.config

import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
  id: root
  clip: true
  visible: items.count > 0
  implicitWidth: parent.width
  implicitHeight: layout.implicitHeight + 8

  ColumnLayout {
    id: layout
    spacing: 4
    anchors.centerIn: parent
    implicitWidth: parent.width

    Repeater {
      id: items
      model: SystemTray.items
      delegate: Item {
        id: trayItem
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: 22
        implicitHeight: 22
        required property SystemTrayItem modelData

        Rectangle {
          anchors.fill: parent
          radius: 5
          color: ma.containsMouse
            ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
            : "transparent"
          Behavior on color { ColorAnimation { duration: 110 } }
        }

        IconImage {
          asynchronous: true
          anchors.centerIn: parent
          width: 13
          height: 13
          source: {
            let icon = trayItem.modelData.icon;
            if (icon.includes("?path=")) {
              const [name, path] = icon.split("?path=");
              icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
          }
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: event => {
            if (event.button === Qt.LeftButton) {
              trayItem.modelData.activate();
            } else if (trayItem.modelData.hasMenu) {
              const pos = mapToItem(mainWindow.contentItem, trayItem.width + 8, 0);
              trayItem.modelData.display(mainWindow, pos.x, pos.y);
            }
          }
        }
      }
    }
  }

  Behavior on implicitHeight {
    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
  }
}
