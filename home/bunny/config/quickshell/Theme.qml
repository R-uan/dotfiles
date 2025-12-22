pragma Singleton
import QtQuick
import Quickshell

Singleton {
  // Bar Design
  property int barHeight: 33
  property int barWidth: 1000
  property real backgroundOpacity: 1

  property int radius: 6
  property int spacing: 3
  property int margins: 2

  // Font
  property int fontSize: 14
  property int fontWeight: 400
  property string fontFamily: "Iosevka"

  // Colour Palette
  property string pink: "#fd9eff"
  property string purple: "#C192E8"
  property string dpurple: "#523F66"
  property string blue: "#7CADB3"
  property string green: "#758562"
  property string dgreen: "#445937"
  property string black: "#070707"
  property string blackAlt: "#272727"

  property string rose: "#D46A8C"

  // Colour Scheme
  property string foreground: purple
  property string background: black
  property string borderColour: blackAlt

  property string primary: purple
  property string primaryHover: "#4D3F57"
  property string secondary: green
  property string secondaryHover: dgreen
  property string tertiary: dpurple
}
