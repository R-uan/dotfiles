import QtQuick
import Quickshell
pragma Singleton

Singleton {
    // Colour Palette
    property string darkLightPurple: "#19161c"
    property string darkPurple: "#17131A"
    property string middPurple: "#5E4870"
    property string lighPurple: "#B7A1D3"
    property string darkGreen: "#536e50"
    property string middGreen: "#749e77"
    property string lighGreen: "#E6FFE6"
    property string rose: "#D46A8C"
    property string gray: "#CFC6C2"
    property string peach: "#FFD6BA"
    property string lavender: "#D9C3FF"
    // Bar Design
    property int height: 40
    property int radius: 2
    property int spacing: 3
    property int margins: 200
    property bool fullBar: true
    property real backgroundOpacity: 1
    property int fontSize: 12
    property int fontWeight: 200
    property string fontFamily: "Adwaita Mono"
    // Colour Scheme
    property string primaryHover: lighPurple
    property string secondaryHover: lighGreen
    property string primaryAccent: middPurple
    property string secondaryAccent: middGreen
    property string background: darkLightPurple // "#1d1421"
    property string foreground: lighGreen
    property string foregroundHover: darkPurple
    property int separatorSize: 10
    property string separator: ""
    property string separatorForeground: foreground
    property string border: "transparent"
    property int barBorderWidth: 3
    property string barBorderColor: "#251f29"
}
