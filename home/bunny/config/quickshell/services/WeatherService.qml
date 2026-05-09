// WeatherService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // — Set your location here —
  property string location: "Salvador_Bahia"

  // — Exposed state —
  property string condition: "—"
  property string tempC: "—"
  property string humidity: "—"
  property string windSpeed: "—"
  property string windDir: "—"
  property bool loading: true
  property bool hasError: false

  // — Fetch —
  function fetch() {
    fetcher.running = true;
  }

  Process {
    id: fetcher
    command: ["curl", "-sf", "https://wttr.in/" + root.location + "?format=j1"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const data = JSON.parse(text);
          const c = data.current_condition[0];
          root.tempC = c.temp_C;
          root.humidity = c.humidity;
          root.windSpeed = c.windspeedKmph;
          root.windDir = c.winddir16Point;
          root.condition = c.weatherDesc[0].value;
          root.loading = false;
          root.hasError = false;
        } catch (e) {
          root.hasError = true;
          root.loading = false;
        }
      }
    }
  }

  // — Refresh every minute —
  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: root.fetch()
  }
}
