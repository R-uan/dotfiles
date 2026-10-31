import qs.config

import QtQuick
import Quickshell
import Quickshell.Wayland

// A popup that hangs off the bar instead of floating beside it (caelestia's
// drawers): flush against the left bar and the top/bottom border, rounded
// only on its free corners, with concave fillets wherever it meets the frame
// so panel and bars read as one surface. Unfurls out of the bar on open.
//
// The layer shell places it beside the bars' exclusive zones, so (0,0) of
// this window is already the inner corner of the frame.
//
//   edge: "top"     under the top border     (start menu)
//         "bottom"  above the bottom border  (status menus)
//         "center"  vertically centred       (calendar)
//         "full"    top border to bottom     (wallpaper picker)
//
// Children go inside the card, which is cardWidth x cardHeight.
PanelWindow {
  id: panel

  property string edge: "bottom"
  property int cardWidth: 320
  property int cardHeight: 200
  default property alias content: body.data
  // Close on any click outside the card. For panels driven from the
  // keyboard, where the hover-out timer never starts.
  property bool modal: false

  WlrLayershell.layer: modal ? WlrLayer.Overlay : WlrLayer.Top

  // Full-screen, invisible click catcher one layer below the card.
  PanelWindow {
    screen: panel.screen
    visible: panel.modal && panel.visible
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:dismiss"
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.AllButtons
      onPressed: panel.visible = false
    }
  }

  readonly property int _r: Config.rounding
  readonly property bool _top: edge === "top" || edge === "full"
  readonly property bool _bottom: edge === "bottom" || edge === "full"
  readonly property color _colour: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0

  // Room for the fillets: beside the card where it meets a border, and
  // above/below it where it leaves the bar.
  readonly property int _padTop: edge === "bottom" || edge === "center" ? _r : 0
  readonly property int _padBottom: edge === "top" || edge === "center" ? _r : 0

  color: "transparent"
  exclusionMode: ExclusionMode.Normal
  anchors.left: true
  anchors.top: _top
  anchors.bottom: _bottom
  implicitWidth: cardWidth + (_top || _bottom ? _r : 0)
  implicitHeight: cardHeight + _padTop + _padBottom
  // Only the card takes input; the fillets and padding are see-through.
  mask: Region { item: card }

  // 0 -> 1 on open; drives the unfurl. Closing is instant, as before.
  property real _reveal: 0
  onVisibleChanged: if (visible) revealAnim.restart()

  NumberAnimation {
    id: revealAnim
    target: panel
    property: "_reveal"
    from: 0
    to: 1
    duration: Motion.spatialDuration
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Motion.spatial
  }

  Item {
    id: card
    x: 0
    y: panel._padTop
    width: Math.max(0, panel.cardWidth * panel._reveal)
    height: panel.edge === "full" ? panel.height : panel.cardHeight
    clip: true
    opacity: Math.min(1, panel._reveal * 2)

    // Oversized so only the free corners show rounding: corners touching
    // the bar or a border are pushed outside the clip.
    Rectangle {
      x: -panel._r
      y: panel._top ? -panel._r : 0
      width: parent.width + panel._r
      height: parent.height + (panel._top ? panel._r : 0) + (panel._bottom ? panel._r : 0)
      radius: panel._r
      color: panel._colour
      opacity: Config.backgroundOpacity
    }

    Item {
      id: body
      width: panel.cardWidth
      height: card.height
    }
  }

  // ── Fillets ────────────────────────────────────────────────────
  readonly property real _filletOpacity: card.opacity * Math.min(1, card.width / (_r * 2))

  // Card leaving the bar, above / below it
  RoundCorner {
    visible: panel._padTop > 0 && panel._filletOpacity > 0.05
    x: 0
    y: 0
    implicitSize: panel._r
    corner: RoundCorner.CornerEnum.BottomLeft
    color: panel._colour
    opacity: panel._filletOpacity
  }
  RoundCorner {
    visible: panel._padBottom > 0 && panel._filletOpacity > 0.05
    x: 0
    y: panel._padTop + card.height
    implicitSize: panel._r
    corner: RoundCorner.CornerEnum.TopLeft
    color: panel._colour
    opacity: panel._filletOpacity
  }

  // Card meeting the top / bottom border, to its right
  RoundCorner {
    visible: panel._top && panel._filletOpacity > 0.05
    x: card.width
    y: 0
    implicitSize: panel._r
    corner: RoundCorner.CornerEnum.TopLeft
    color: panel._colour
    opacity: panel._filletOpacity
  }
  RoundCorner {
    visible: panel._bottom && panel._filletOpacity > 0.05
    x: card.width
    y: panel._padTop + card.height - panel._r
    implicitSize: panel._r
    corner: RoundCorner.CornerEnum.BottomLeft
    color: panel._colour
    opacity: panel._filletOpacity
  }
}
