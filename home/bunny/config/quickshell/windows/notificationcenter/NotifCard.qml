import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects

Item {
  id: root
  property var notif
  property bool isActive: true
  signal dismiss()

  implicitHeight: card.implicitHeight

  // Discord & co. wrap names in Unicode isolates (U+2066-2069); they render
  // as junk boxes in some fonts and add nothing.
  function _clean(s) { return String(s).replace(/[⁦-⁩]/g, ""); }

  readonly property string _summary: (notif && notif.summary) ? _clean(notif.summary) : ""
  readonly property string _body:    (notif && notif.body)    ? _clean(notif.body)    : ""
  readonly property string _app:     (notif && notif.app_name) ? String(notif.app_name) : ""
  readonly property string _urg:     (notif && notif.urgency) ? String(notif.urgency) : "normal"
  readonly property bool _canOpen:   isActive && notif && notif.actions && notif.actions["default"] !== undefined
  readonly property string _icon:    AppIcons.source((notif && notif.desktop_entry) || _app.toLowerCase())
  readonly property real _time:      NotificationService.timeOf(notif)

  readonly property color _fg:  Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _dim: Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color _accent: {
    if (_urg === "critical" || _urg === "high")
      return Config.darkMode ? ThemeDark.error : ThemeLight.error;
    if (_urg === "low")
      return Config.darkMode ? ThemeDark.muted : ThemeLight.muted;
    return Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1;
  }

  // "now", "12m", "14:32 · 3h", "yesterday 09:10", "28/10 18:02"
  function _fmtTime(ms, now) {
    if (!ms) return "";
    const d = new Date(ms);
    const hm = Qt.formatTime(d, "HH:mm");
    const mins = Math.floor((now - ms) / 60000);
    if (mins < 1)  return "now";
    if (mins < 60) return mins + "m";
    const today = new Date(now);
    if (d.toDateString() === today.toDateString())
      return hm + " · " + Math.floor(mins / 60) + "h";
    const yesterday = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 1);
    if (d.toDateString() === yesterday.toDateString())
      return "yesterday " + hm;
    return Qt.formatDate(d, "dd/MM") + " " + hm;
  }

  Rectangle {
    id: card
    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: content.implicitHeight + 18
    radius: 10
    color: cardMa.containsMouse && root._canOpen
      ? (Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.06))
      : (Config.darkMode ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0,0,0,0.04))
    border.color: Config.darkMode ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
    border.width: 1
    opacity: root.isActive ? 1 : 0.8
    Behavior on color { CAnim {} }

    MouseArea {
      id: cardMa
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: root._canOpen ? Qt.PointingHandCursor : Qt.ArrowCursor
      onClicked: if (root._canOpen) NotificationService.invoke(root.notif.id)
    }

    RowLayout {
      id: content
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.leftMargin: 10
      anchors.rightMargin: 8
      anchors.topMargin: 9
      spacing: 10

      // App icon (grayscale) with the urgency as a ring
      Item {
        Layout.alignment: Qt.AlignTop
        Layout.preferredWidth: 28
        Layout.preferredHeight: 28

        Rectangle {
          anchors.fill: parent
          radius: 8
          color: Config.darkMode ? Qt.rgba(1,1,1,0.05) : Qt.rgba(0,0,0,0.05)
          border.width: root._urg === "critical" ? 1 : 0
          border.color: root._accent
        }

        IconImage {
          id: appIcon
          anchors.centerIn: parent
          width: 16
          height: 16
          asynchronous: true
          source: root._icon
          visible: false
        }
        MultiEffect {
          anchors.fill: appIcon
          source: appIcon
          saturation: -1
          visible: root._icon.length > 0
        }
        StyledText {
          anchors.centerIn: parent
          visible: root._icon.length === 0
          text: "󰂚"
          font.pixelSize: 14
          color: root._accent
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2

        RowLayout {
          Layout.fillWidth: true
          spacing: 6

          StyledText {
            Layout.fillWidth: true
            text: root._app.length > 0 ? root._app : "notification"
            font.pixelSize: Config.fontSize - 5
            font.letterSpacing: 1.2
            color: root._dim
            elide: Text.ElideRight
          }

          StyledText {
            text: root._fmtTime(root._time, NotificationService.now)
            font.pixelSize: Config.fontSize - 5
            color: root._dim
          }

          // Close button (active only)
          Item {
            visible: root.isActive
            implicitWidth: 18
            implicitHeight: 18

            Rectangle {
              anchors.fill: parent
              radius: 4
              color: closeArea.containsMouse
                ? (Config.darkMode ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0,0,0,0.08))
                : "transparent"
              Behavior on color { CAnim {} }
            }
            StyledText {
              anchors.centerIn: parent
              text: "󰅖"
              font.pixelSize: Config.fontSize - 3
              color: closeArea.containsMouse ? root._fg : root._dim
            }
            MouseArea {
              id: closeArea
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: root.dismiss()
            }
          }
        }

        StyledText {
          Layout.fillWidth: true
          text: root._summary
          visible: root._summary.length > 0
          font.pixelSize: Config.fontSize - 1
          font.weight: Font.Medium
          color: root._fg
          elide: Text.ElideRight
          maximumLineCount: 1
        }

        StyledText {
          Layout.fillWidth: true
          text: root._body
          visible: root._body.length > 0
          font.pixelSize: Config.fontSize - 2
          color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
          wrapMode: Text.WordWrap
          maximumLineCount: 3
          elide: Text.ElideRight
        }
      }
    }
  }
}
