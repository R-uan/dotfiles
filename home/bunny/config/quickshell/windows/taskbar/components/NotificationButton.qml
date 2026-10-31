import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: 26

  readonly property int _count: NotificationService.activeCount
  readonly property bool _hasActive: _count > 0

  Rectangle {
    anchors.centerIn: parent
    width: 26
    height: width
    radius: 7
    color: mouseArea.containsMouse
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
      : "transparent"
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  StyledText {
    id: bell
    text: NotificationService.dnd ? "󰂛" : (root._hasActive ? "󱅫" : "󰂚")
    anchors.centerIn: parent
    font.pixelSize: 14
    color: mouseArea.containsMouse
      ? (Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0)
      : (NotificationService.dnd
          ? (Config.darkMode ? ThemeDark.muted : ThemeLight.muted)
          : (root._hasActive
              ? (Config.darkMode ? ThemeDark.warning : ThemeLight.warning)
              : (Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1)))
    Behavior on color { ColorAnimation { duration: 110 } }
  }

  // Badge count when active (hidden while silenced, mako hides them too)
  Rectangle {
    visible: root._count > 0 && !NotificationService.dnd
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 1
    anchors.rightMargin: 1
    width: Math.max(14, badgeText.implicitWidth + 6)
    height: 14
    radius: 7
    color: Config.darkMode ? ThemeDark.warning : ThemeLight.warning

    StyledText {
      id: badgeText
      anchors.centerIn: parent
      text: root._count > 9 ? "9+" : String(root._count)
      font.pixelSize: 9
      font.weight: Font.Bold
      color: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    onClicked: function (mouse) {
      // Middle click: toggle do-not-disturb.
      if (mouse.button === Qt.MiddleButton) {
        NotificationService.toggleDnd();
        OsdService.show(NotificationService.dnd ? "󰂛" : "󰂚",
                        NotificationService.dnd ? "Do not disturb" : "Notifications on",
                        0, "", NotificationService.dnd, false);
        return;
      }
      if (notificationcenter.visible) {
        notificationcenter.visible = false;
        notificationcenter.timer.running = false;
      } else {
        notificationcenter.visible = true;
      }
    }
  }
}
