pragma Singleton
import qs.config

import QtQuick
import Quickshell
import Quickshell.Io

// Current conditions + 3-day forecast from wttr.in's JSON endpoint.
// The last good reading is kept when a fetch fails (offline, rate limit).
Singleton {
  id: root

  property bool ready: false
  property string location: ""
  property int temp: 0
  property int feelsLike: 0
  property int humidity: 0
  property int wind: 0            // km/h
  property string description: ""
  property string icon: ""
  property var forecast: []       // list of { day, icon, max, min }

  // WWO weather codes, as used by wttr.in, to nerd-font weather glyphs.
  function iconFor(code, night) {
    const c = parseInt(code);
    if (c === 113) return night ? "󰖔" : "󰖙";
    if (c === 116) return night ? "󰼱" : "󰖕";
    if (c === 119 || c === 122) return "󰖐";
    if ([143, 248, 260].includes(c)) return "󰖑";
    if ([200, 386, 389, 392, 395].includes(c)) return "󰖓";
    if ([179, 182, 185, 227, 230, 281, 284, 311, 314, 317, 320, 323, 326, 329, 332,
         335, 338, 350, 362, 365, 368, 371, 374, 377].includes(c)) return "󰖘";
    if ([302, 305, 308, 356, 359].includes(c)) return "󰖖";
    return "󰖗";
  }

  function refresh() {
    if (Config.weatherEnabled) fetchProc.running = true;
  }

  Process {
    id: fetchProc
    running: Config.weatherEnabled
    command: ["curl", "-sf", "--max-time", "15",
              "https://wttr.in/" + encodeURIComponent(Config.weatherLocation) + "?format=j1"]
    stdout: StdioCollector {
      onStreamFinished: {
        let data;
        try { data = JSON.parse(text); } catch (e) { return; }
        const cur = data.current_condition && data.current_condition[0];
        if (!cur) return;

        const hour = new Date().getHours();
        root.temp        = parseInt(cur.temp_C) || 0;
        root.feelsLike   = parseInt(cur.FeelsLikeC) || 0;
        root.humidity    = parseInt(cur.humidity) || 0;
        root.wind        = parseInt(cur.windspeedKmph) || 0;
        root.description = (cur.weatherDesc && cur.weatherDesc[0] ? cur.weatherDesc[0].value : "").trim();
        root.icon        = root.iconFor(cur.weatherCode, hour < 6 || hour >= 19);

        const area = data.nearest_area && data.nearest_area[0];
        root.location = area && area.areaName && area.areaName[0] ? area.areaName[0].value : "";

        const days = [];
        for (let d of (data.weather || []).slice(0, 3)) {
          // hourly[4] is the 12:00 slot, a fair summary of the day.
          const midday = d.hourly && d.hourly[4] ? d.hourly[4].weatherCode : 113;
          const date = new Date(d.date + "T12:00:00");
          days.push({
            day:  days.length === 0 ? "Today" : Qt.locale(Config.timeLocale).dayName(date.getDay(), Locale.ShortFormat).replace(".", ""),
            icon: root.iconFor(midday, false),
            max:  parseInt(d.maxtempC) || 0,
            min:  parseInt(d.mintempC) || 0
          });
        }
        root.forecast = days;
        root.ready = true;
      }
    }
  }

  Timer {
    interval: 30 * 60 * 1000
    running: Config.weatherEnabled
    repeat: true
    onTriggered: root.refresh()
  }
}
