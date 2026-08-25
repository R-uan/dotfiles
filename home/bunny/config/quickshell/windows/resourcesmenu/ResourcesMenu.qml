import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
  id: resMenu
  visible: false
  implicitWidth: 320
  color: "transparent"
  objectName: "Resources Menu"
  height: mainLayout.implicitHeight + 28
  exclusionMode: ExclusionMode.Normal

  anchors {
    bottom: true
    left: true
    top: false
    right: false
  }

  margins {
    bottom: 6
    left: 6
  }

  Background {
    radius: 14
  }

  property alias timer: timer

  Timer {
    id: timer
    interval: 1000
    running: false
    onTriggered: resMenu.visible = false
  }

  MouseArea {
    hoverEnabled: true
    anchors.fill: parent
    propagateComposedEvents: true
    onExited: timer.running = true
    onEntered: {
      timer.running = false
      timer.interval = 1000
    }
  }

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
  function _fmtGiB(bytes) {
    const g = bytes / (1024*1024*1024);
    return (g >= 10 ? g.toFixed(1) : g.toFixed(2));
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
        text: "󰍛"
        font.pixelSize: Config.fontSize + 4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      StyledText {
        text: "Resources"
        font.pixelSize: Config.fontSize - 1
        font.letterSpacing: 1.4
        color: Config.darkMode ? ThemeDark.primary1 : ThemeLight.primary1
      }
      Item { Layout.fillWidth: true }
      StyledText {
        text: UptimeService.uptime
        font.pixelSize: Config.fontSize - 4
        color: Config.darkMode ? ThemeDark.primary3 : ThemeLight.primary3
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // ── CPU ───────────────────────────────────────────
    ResBar {
      label: "CPU"
      percent: ResourcesService.cpu
      rightText:ResourcesService.cpu + "%"
      hint: ResourcesService.cpuTemp > 0 ? (ResourcesService.cpuTemp + "°C") : ""
      hintColor: resMenu._tempColor(ResourcesService.cpuTemp)
      fillColor: resMenu._pctColor(ResourcesService.cpu)
    }

    // ── RAM ───────────────────────────────────────────
    ResBar {
      label: "RAM"
      percent: ResourcesService.ramPct
      rightText:ResourcesService.ramPct + "%"
      hint: resMenu._fmtGiB(ResourcesService.ramUsedBytes) + " / "
            + resMenu._fmtGiB(ResourcesService.ramTotalBytes) + " GiB"
      fillColor: resMenu._pctColor(ResourcesService.ramPct)
    }

    // ── Swap ──────────────────────────────────────────
    ResBar {
      visible: ResourcesService.swapTotalBytes > 1
      label: "SWAP"
      percent: ResourcesService.swapPct
      rightText:ResourcesService.swapPct + "%"
      hint: resMenu._fmtGiB(ResourcesService.swapUsedBytes) + " / "
            + resMenu._fmtGiB(ResourcesService.swapTotalBytes) + " GiB"
      fillColor: resMenu._pctColor(ResourcesService.swapPct)
    }

    // ── GPU ───────────────────────────────────────────
    ResBar {
      visible: ResourcesService.hasGpu
      label: "GPU"
      percent: ResourcesService.gpu
      rightText:ResourcesService.gpu + "%"
      hint: ResourcesService.gpuTemp > 0 ? (ResourcesService.gpuTemp + "°C") : ""
      hintColor: resMenu._tempColor(ResourcesService.gpuTemp)
      fillColor: resMenu._pctColor(ResourcesService.gpu)
    }

    // ── VRAM ──────────────────────────────────────────
    ResBar {
      visible: ResourcesService.hasGpu
      label: "VRAM"
      percent: ResourcesService.gpuMemPct
      rightText:ResourcesService.gpuMemPct + "%"
      hint: ResourcesService.gpuMemUsedMiB + " / "
            + ResourcesService.gpuMemTotalMiB + " MiB"
      fillColor: resMenu._pctColor(ResourcesService.gpuMemPct)
    }
  }
}
