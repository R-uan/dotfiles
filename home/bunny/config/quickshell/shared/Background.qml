import qs.config

import QtQuick
import QtQuick.Window

Rectangle {
  border.width: 1
  width: parent.width
  radius: Config.radius
  height: parent.height
  opacity: Config.backgroundOpacity
  border.color: Config.darkMode ? ThemeDark.border : ThemeLight.border
  color: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
}
