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
  implicitHeight: layout.height + 10
  readonly property string accentColor: Config.darkMode ? ThemeDark.colour6 : ThemeLight.primary3


  ColumnLayout {
    id: layout
    spacing: 5
    anchors.centerIn: parent
    implicitWidth: parent.width - 8

    Background {
      anchors.fill: parent
      color: root.accentColor
      visible: Config.darkMode === false
    }

    Repeater {
      id: items
      model: SystemTray.items
      delegate: MouseArea {
        id: trayItem
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: Config.fontSize * 1.09
        implicitHeight: Config.fontSize * 1.09
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        Layout.bottomMargin: 5
        required property SystemTrayItem modelData

        onClicked: event => {
          if (event.button === Qt.LeftButton) {
            modelData.activate();
          } else {
            if (modelData.hasMenu) {
              const pos = mapToItem(mainWindow.contentItem, 0, height + 10);
              modelData.display(mainWindow, pos.x, pos.y);
            }
          }
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
