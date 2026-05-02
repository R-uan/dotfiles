pragma Singleton
import QtQuick
import Quickshell

Singleton {
  // Bar Design
  property int radius: 7
  property int spacing: 5
  property int margins: 2
  property int barHeight: 32
  property int barWidth: 1500
  property real backgroundOpacity: 0.93
  // Font
  property int fontSize: 14
  property int fontWeight: 400
  property string fontFamily: "Iosevka"
  // Colour Palette
  property string greenDarker: "#2d3a2e"
  property string greenDark: "#3d4a3e"
  property string greenMid: "#6b7c6e"
  property string greenBase: "#8a9d8f"
  property string greenLight: "#a8b9aa"
  property string greenLighter: "#c5d3c6"
  property string greenAccent: "#7a9b7f"
  property string greenWarm: "#8d9e88"
  property string greenCool: "#84a089"
  property string grey: "#5a6a5a"
  property string success: "#7a9b7f"
  property string warning: "#9da88d"
  property string error: "#9d8a8a"
  // Backgrounds
  property string bg0: "transparent"
  property string bg1: "#1a1f1a"
  property string bg2: "#232823"
  property string bg3: "#2d322d"
  property string black: "#171919"
  // Colour Scheme
  property string primary: greenMid
  property string secondary: greenDarker
  property string tertiary: greenWarm

  property string background: black
  property string foreground: greenLighter
  property string borderColour: "#303030"

  property string primaryHover: greenLighter
  property string secondaryHover: greenDark
}
