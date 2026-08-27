import qs.shared
import qs.config
import qs.services

import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts

PanelWindow {
  id: resMenu
  visible: false
  color: "transparent"
  objectName: "Resources Menu"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  anchors { top: true; left: true; right: true; bottom: true }

  // Geometry of the surrounding bars, so the card can dock flush to them.
  readonly property int _barWidth: Config.thickness + 10
  readonly property int _edgeBar: 7
  readonly property int _cornerRadius: Config.rounding
  readonly property int _cardWidth: 320
  readonly property int _cardHeight: mainLayout.implicitHeight + 28
  readonly property color _cardColor: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0

  // Screen-space vertical centre the card lines up with. The Resources
  // button in the bar sets this to its own centre before showing us.
  property real anchorCenterY: 140
  property bool _presented: false

  // Keep the whole card (plus its corner fillets) inside the free area
  // between the top and bottom bars.
  readonly property real _cardY: Math.max(
    _edgeBar + _cornerRadius,
    Math.min(anchorCenterY - _cardHeight / 2,
             height - _edgeBar - _cornerRadius - _cardHeight))

  onVisibleChanged: _presented = visible

  property alias timer: closeTimer

  Timer {
    id: closeTimer
    interval: 1
    onTriggered: resMenu.visible = false
  }

  // Click-outside catcher
  MouseArea {
    anchors.fill: parent
    onClicked: resMenu.visible = false
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

  // ── Card body ────────────────────────────────────────────────
  // Square left corners (flat against the bar), rounded right corners.
  // A taller-than-visible inner rectangle inside a clip:true item crops
  // the left rounding away; the card unfurls rightward out of the bar.
  Item {
    id: assembly
    x: resMenu._barWidth
    y: resMenu._cardY
    width: resMenu._presented ? resMenu._cardWidth : 0
    height: resMenu._cardHeight
    clip: true

    opacity: resMenu._presented ? 1 : 0
    Behavior on width {
      NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
    }
    Behavior on opacity {
      NumberAnimation { duration: 180 }
    }

    Rectangle {
      x: -resMenu._cornerRadius
      y: 0
      width: parent.width + resMenu._cornerRadius
      height: parent.height
      radius: resMenu._cornerRadius
      color: resMenu._cardColor
    }

    // Eat clicks on the card so the outside catcher doesn't dismiss us.
    MouseArea { anchors.fill: parent; onClicked: {} }

    ColumnLayout {
      id: mainLayout
      spacing: 10
      width: resMenu._cardWidth - 28
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

  // ── Rounded outer corners at the card/left-bar junctions ──────
  // Same pattern the taskbar uses at its screen corners: a RoundCorner
  // filled with the card colour, its sharp corner butted against the
  // card's corner, so the L-junction with the bar reads as a smooth
  // concave transition instead of a sharp reflex angle.
  readonly property real _filletOpacity:
    assembly.opacity * Math.min(1, assembly.width / (_cornerRadius * 2))

  RoundCorner {
    x: resMenu._barWidth
    y: resMenu._cardY - resMenu._cornerRadius
    implicitSize: resMenu._cornerRadius
    corner: RoundCorner.CornerEnum.BottomLeft
    color: resMenu._cardColor
    visible: resMenu._filletOpacity > 0.05
    opacity: resMenu._filletOpacity
  }

  RoundCorner {
    x: resMenu._barWidth
    y: resMenu._cardY + resMenu._cardHeight
    implicitSize: resMenu._cornerRadius
    corner: RoundCorner.CornerEnum.TopLeft
    color: resMenu._cardColor
    visible: resMenu._filletOpacity > 0.05
    opacity: resMenu._filletOpacity
  }
}
