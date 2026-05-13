import qs.shared
import qs.config
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
  id: root

  function conditionIcon(desc) {
    const d = desc.toLowerCase();
    if (d.includes("sunny") || d.includes("clear"))      return "☀️";
    if (d.includes("partly cloudy"))                      return "⛅";
    if (d.includes("cloud") || d.includes("overcast"))   return "☁";
    if (d.includes("drizzle") || d.includes("light rain")) return "🌦";
    if (d.includes("rain") || d.includes("shower"))      return "🌧";
    if (d.includes("thunder") || d.includes("storm"))    return "⛈";
    if (d.includes("snow") || d.includes("sleet"))       return "🌨";
    if (d.includes("fog") || d.includes("mist"))         return "🌫";
    if (d.includes("blizzard"))                          return "❄";
    return "🌡";
  }

  // — Loading —
  StyledText {
    text: "Loading…"
    anchors.centerIn: parent
    visible: WeatherService.loading
  }

  // — Error —
  StyledText {
    color: Config.darkMode ? ThemeDark.error : ThemeLight.error
    anchors.centerIn: parent
    text: "Could not fetch weather"
    font.pixelSize: Config.fontSize - 2
    visible: WeatherService.hasError && !WeatherService.loading
  }

  // — Content —
  RowLayout {
    spacing: 15
    visible: !WeatherService.loading && !WeatherService.hasError
    anchors.centerIn: parent

    // Left: icon
    StyledText {
      font.pixelSize: 35
      Layout.alignment: Qt.AlignVCenter
      text: root.conditionIcon(WeatherService.condition)
    }

    // Right: info
    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: 3

      StyledText {
        font.pixelSize: 20
        font.weight: Font.Medium
        text: WeatherService.tempC + "°C"
      }

      StyledText {
        text: WeatherService.condition.length >= 14
          ? `${WeatherService.condition.slice(0, 11).trim()}...`
          : WeatherService.condition
        font.pixelSize: Config.fontSize - 2
      }
    }

    ColumnLayout {
      RowLayout {
        spacing: 4
        StyledText { text: "💧"; font.pixelSize: 11 }
        StyledText { text: WeatherService.humidity + "%"; font.pixelSize: Config.fontSize - 2 }
      }
      RowLayout {
        spacing: 4
        StyledText { text: "💨"; font.pixelSize: 11 }
        StyledText { text: WeatherService.windSpeed + " km/h"; font.pixelSize: Config.fontSize - 2 }
      }
    }
  }
}
