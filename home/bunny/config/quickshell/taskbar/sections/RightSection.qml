import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.taskbar.shared
import qs.taskbar.modules
import qs.taskbar.services
import Quickshell.Services.Notifications

// Right Section
Rectangle {
  id: root
  color: "transparent"
  radius: Theme.radius
  height: parent.height
  implicitWidth: layout.implicitWidth

  RowLayout {
    id: layout
    spacing: 5
    anchors.fill: parent

    Tray {
      Layout.preferredHeight: parent.height
    }
    SysResources {
      Layout.minimumHeight: parent.height
    }

    Item {
      Layout.preferredWidth: 15
      Text {
        text: ""
        anchors.centerIn: parent
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.weight: Theme.fontWeight
        font.pixelSize: Theme.fontSize / 3
      }
    }

    // Network
    Item {
      Layout.minimumHeight: parent.height
      Layout.minimumWidth: 20

      CommonText {
        id: textItem
        color: Theme.foreground
        anchors.centerIn: parent
        text: NetworkManager.connection
      }
    }

    // Notifications
    Item {
      id: notificationRoot
      Layout.minimumWidth: 20
      Layout.minimumHeight: parent.height

      CommonText {
        text: "󰂜"
        anchors.centerIn: parent
      }

      MouseArea {
        id: notificationMouseArea
        anchors.fill: parent
        onClicked: {
          if (notificationPopup.visible)
            notificationPopup.visible = false;
          else {
            const position = root.mapToItem(mainWindow.contentItem, root.width, root.height + 5);
            notificationPopup.display(position.x - notificationPopup.implicitWidth + 10, position.y);
          }
        }
      }
      // Where notifications cards will show up.
      PopupWindow {
        id: notificationPopup
        visible: false
        implicitWidth: 400
        implicitHeight: 250
        color: "transparent"
        anchor.window: mainWindow

        function display(x, y) {
          notificationPopup.anchor.rect.x = x;
          notificationPopup.anchor.rect.y = y;
          notificationPopup.visible = true;
          let hello = NotificationServer.trackedNotifications;
          console.log(hello);
        }

        Rectangle {
          border.width: 2
          anchors.fill: parent
          color: Theme.background
          topLeftRadius: Theme.radius
          topRightRadius: Theme.radius
          bottomLeftRadius: Theme.radius
          bottomRightRadius: Theme.radius
          border.color: Theme.borderColour
          opacity: Theme.backgroundOpacity
        }
      }
    }
  }
}
