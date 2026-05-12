pragma Singleton
import QtQuick

QtObject {
  // Ramp — 0 = deepest, 7 = lightest
  readonly property string colour0: "#1a2a1c"
  readonly property string colour1: "#263328"
  readonly property string colour2: "#374a39"
  readonly property string colour3: "#5c7060"
  readonly property string colour4: "#83977f"
  readonly property string colour5: "#8d9e82"
  readonly property string colour6: "#a3b89e"
  readonly property string colour7: "#c2d4bc"

  // Semantic
  readonly property string success: "#7a9e78"
  readonly property string warning: "#a8a87a"
  readonly property string error:   "#a07a7a"
  readonly property string muted:   "#536655"

  // Colour scheme
  readonly property string primary0:      colour4
  readonly property string primary1:      colour5
  readonly property string primary2:      colour1
  readonly property string primary3:      colour3
  readonly property string primary0Hover: "#9aad96"
  readonly property string primary2Hover: colour2

  // Backgrounds (darkest → lightest surface)
  readonly property string background0: "#171919"
  readonly property string background1: "#1c231e"
  readonly property string background2: "#263328"
  readonly property string border:      background1

  // Foreground
  readonly property string foreground0: "#D3C6AA"
  readonly property string foreground1: "#e8e0cd"
}
