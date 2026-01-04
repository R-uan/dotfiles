pragma Singleton
import QtQuick
import Quickshell

Singleton {
  // Bar Design
  property int barHeight: 33
  property int barWidth: 1500
  property real backgroundOpacity: 1
  property int radius: 4
  property int spacing: 3
  property int margins: 2
  // Font
  property int fontSize: 14
  property int fontWeight: 400
  property string fontFamily: "Iosevka"
  // Colour Palette

  property string purple: "#b692d4"
  property string lpurple: "#d4b5e8"
  property string dpurple: "#4a3358"

  property string purpleAlt: "#6b4d82"
  property string lpurpleAlt: "#c4a3e0"
  property string dpurpleAlt: "#32233d"

  property string green: "#7fb069"
  property string lgreen: "#a8c69f"
  property string dgreen: "#3d4a34"

  property string greenAlt: "#556b47"
  property string lgreenAlt: "#8fc277"
  property string dgreenAlt: "#2a3424"

  property string black: "#070707"
  property string blackAlt: "#202020"

  property string rose: "#D46A8C"
  property string lrose: "#fd9eff"
  // Colour Scheme
  property string primary: green
  property string secondary: purple
  property string tertiary: greenAlt

  property string foreground: lgreen
  property string background: black

  property string borderColour: blackAlt

  property string primaryHover: lgreen
  property string secondaryHover: dpurple
  property string tertiaryHover: dpurpleAlt
}
