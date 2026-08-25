import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: layout.implicitHeight + 6

  function _pctColor(pct) {
    if (pct >= 90) return Config.darkMode ? ThemeDark.error   : ThemeLight.error;
    if (pct >= 75) return Config.darkMode ? ThemeDark.warning : ThemeLight.warning;
    return Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1;
  }
  function _tempColor(t) {
    if (t >= 85) return Config.darkMode ? ThemeDark.error   : ThemeLight.error;
    if (t >= 70) return Config.darkMode ? ThemeDark.warning : ThemeLight.warning;
    return Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1;
  }

  ColumnLayout {
    id: layout
    anchors.centerIn: parent
    spacing: 8
    width: parent.width

    // Hover container that toggles the details menu.
    MouseArea {
      id: hoverArea
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: statsCol.implicitHeight
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (resourcesmenu.visible) {
          resourcesmenu.visible = false;
          resourcesmenu.timer.running = false;
        } else {
          resourcesmenu.visible = true;
        }
      }

      ColumnLayout {
        id: statsCol
        anchors.centerIn: parent
        spacing: 10

        // ── CPU ─────────────────────────────────────────
        StatCell {
          label: "CPU"
          percent: ResourcesService.cpu
          fillColor: root._pctColor(ResourcesService.cpu)
        }

        // ── RAM ─────────────────────────────────────────
        StatCell {
          label: "RAM"
          percent: ResourcesService.ramPct
          fillColor: root._pctColor(ResourcesService.ramPct)
        }

        // ── TEMP ────────────────────────────────────────
        StatCell {
          label: ResourcesService.cpuTemp + "°C"
          percent: Math.min(100, ResourcesService.cpuTemp)
          icon: "󰔏"
          fillColor: root._tempColor(ResourcesService.cpuTemp)
        }
      }
    }
  }
}
