pragma Singleton
import QtQuick

QtObject {
  // Ramp — 0 = deepest, 7 = lightest
  readonly property string colour0: "#1a2a1c"   // near-black forest
  readonly property string colour1: "#2e4a30"   // deep forest
  readonly property string colour2: "#4a6e4d"   // strong mid-green
  readonly property string colour3: "#6a9470"   // readable accent
  readonly property string colour4: "#8daa88"   // soft accent
  readonly property string colour5: "#b0c8aa"   // muted tint
  readonly property string colour6: "#c8d8c2"   // surface tint
  readonly property string colour7: "#d8e5d2"   // lightest — warm sage, not white

  // Semantic
  readonly property string success: "#3a7a3a"
  readonly property string warning: "#7a7a20"
  readonly property string error:   "#8a3a3a"
  readonly property string muted:   "#6a8a6a"

  // Colour scheme
  readonly property string primary0:      colour3
  readonly property string primary1:      colour4
  readonly property string primary2:      colour6
  readonly property string primary3:      colour2
  readonly property string primary0Hover: colour2
  readonly property string primary2Hover: colour5

  // Backgrounds (lightest → darkest surface)
  readonly property string background0: "#d8e5d2"   // page bg  — muted sage
  readonly property string background1: "#c8d8c2"   // surface
  readonly property string background2: "#b8ccb0"   // raised
  readonly property string border:      "#90aa88"   // clearly visible on all bg levels

  // Foreground
  readonly property string foreground0: "#1a2a1c"   // primary text
  readonly property string foreground1: "#3a5a3c"   // secondary text
}
