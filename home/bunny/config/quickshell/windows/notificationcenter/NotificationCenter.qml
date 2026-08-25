import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
  id: notifCenter
  visible: false
  implicitWidth: 340
  color: "transparent"
  objectName: "Notification Center"
  height: mainLayout.implicitHeight + 28
  exclusionMode: ExclusionMode.Normal

  anchors {
    top: true
    left: true
    right: false
    bottom: false
  }

  margins {
    top: 6
    left: 6
  }

  Background {
    radius: 14
  }

  property alias timer: timer

  onVisibleChanged: {
    if (visible) NotificationService.refresh();
  }

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: notifCenter.visible = false
  }

  MouseArea {
    id: area
    hoverEnabled: true
    anchors.fill: parent
    propagateComposedEvents: true
    onExited: timer.running = true
    onEntered: {
      timer.running = false
      timer.interval = 1000
    }
  }

  ColumnLayout {
    id: mainLayout
    spacing: 10
    width: parent.width - 28
    x: 14
    y: 14

    // Header
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      StyledText {
        text: "󰂚"
        font.pixelSize: Config.fontSize + 4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      StyledText {
        text: "Notifications"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: NotificationService.activeCount + " active · " + NotificationService.historyCount + " past"
        font.pixelSize: Config.fontSize - 3
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
    }

    // Divider
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // Empty state
    StyledText {
      Layout.fillWidth: true
      Layout.topMargin: 20
      Layout.bottomMargin: 20
      horizontalAlignment: Text.AlignHCenter
      visible: NotificationService.activeCount === 0 && NotificationService.historyCount === 0
      text: "All caught up."
      font.pixelSize: Config.fontSize - 1
      color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
    }

    // ── Active section ─────────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6
      visible: NotificationService.activeCount > 0

      RowLayout {
        Layout.fillWidth: true
        StyledText {
          text: "ACTIVE"
          font.pixelSize: Config.fontSize - 4
          font.letterSpacing: 1.6
          color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        }
        Item { Layout.fillWidth: true }
        NotifActionButton {
          label: "Dismiss all"
          onClicked: NotificationService.dismissAll()
        }
      }

      Repeater {
        model: NotificationService.active
        delegate: NotifCard {
          Layout.fillWidth: true
          notif: modelData
          isActive: true
          onDismiss: NotificationService.dismiss(modelData.id)
        }
      }
    }

    // ── History section ────────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6
      visible: NotificationService.historyCount > 0

      RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: NotificationService.activeCount > 0 ? 6 : 0

        StyledText {
          text: "HISTORY"
          font.pixelSize: Config.fontSize - 4
          font.letterSpacing: 1.6
          color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
        }
        Item { Layout.fillWidth: true }
        NotifActionButton {
          label: "Clear"
          onClicked: NotificationService.clearHistory()
        }
      }

      Repeater {
        // cap to 25 to keep the panel bounded
        model: NotificationService.history.slice(0, 25)
        delegate: NotifCard {
          Layout.fillWidth: true
          notif: modelData
          isActive: false
        }
      }
    }
  }
}
