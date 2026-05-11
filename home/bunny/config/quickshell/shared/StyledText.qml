import qs.config

import QtQuick

Text {
  font.family: Config.fontFamily
  font.weight: Config.fontWeight
  font.pixelSize: Config.fontSize
  color: Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
}
