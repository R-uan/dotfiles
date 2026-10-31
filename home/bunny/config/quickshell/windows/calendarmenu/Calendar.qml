import qs.config
import qs.shared

import QtQuick
import QtQuick.Layouts

// Month grid with ISO week numbers, neighbouring-month days, national
// holidays and a "days from today" readout for the clicked day. Names come
// from Config.timeLocale (LC_TIME), the interface text stays English.
Item {
  id: root
  implicitHeight: layout.implicitHeight

  // — Theme aliases —
  readonly property color colFg:      Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color colBright:  Config.darkMode ? ThemeDark.foreground1 : ThemeLight.foreground1
  readonly property color colAccent:  Config.darkMode ? ThemeDark.primary1    : ThemeLight.primary1
  readonly property color colDim:     Config.darkMode ? ThemeDark.primary3    : ThemeLight.primary3
  readonly property color colMuted:   Config.darkMode ? ThemeDark.muted       : ThemeLight.muted
  readonly property color colToday:   Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color colOnToday: Config.darkMode ? ThemeDark.background0 : ThemeLight.background0
  readonly property color colHover:   Config.darkMode ? Qt.rgba(1,1,1,0.07)   : Qt.rgba(0,0,0,0.06)

  readonly property var loc: Qt.locale(Config.timeLocale)

  // — State —
  property var today: new Date()
  property int displayYear: today.getFullYear()
  property int displayMonth: today.getMonth()
  property var selected: null          // Date, or null
  property int _slideDir: 0            // -1 back, 1 forward; drives the slide

  readonly property bool viewingCurrent: displayMonth === today.getMonth() &&
                                         displayYear === today.getFullYear()

  readonly property int weekColW: 26
  readonly property int cellW: Math.floor((root.width - weekColW) / 7)
  readonly property int cellH: 28

  // First column follows the locale (Sunday for pt_BR).
  readonly property int firstDow: loc.firstDayOfWeek % 7   // 0 = Sunday

  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: root.today = new Date()
  }

  function cap(s) { return s.length ? s.charAt(0).toUpperCase() + s.slice(1) : s; }

  function sameDay(a, b) {
    return a && b && a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth()
           && a.getDate() === b.getDate();
  }

  // ISO-8601 week number.
  function isoWeek(d) {
    const t = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
    const day = t.getUTCDay() || 7;
    t.setUTCDate(t.getUTCDate() + 4 - day);
    const yearStart = new Date(Date.UTC(t.getUTCFullYear(), 0, 1));
    return Math.ceil(((t - yearStart) / 86400000 + 1) / 7);
  }

  // Date shown in grid cell `i` (0..41) for the displayed month.
  function cellDate(i) {
    const first = new Date(displayYear, displayMonth, 1);
    const lead = (first.getDay() - root.firstDow + 7) % 7;
    return new Date(displayYear, displayMonth, 1 - lead + i);
  }

  // ── Holidays ─────────────────────────────────────────────────
  // Anonymous Gregorian algorithm.
  function easter(y) {
    const a = y % 19, b = Math.floor(y / 100), c = y % 100;
    const d = Math.floor(b / 4), e = b % 4, f = Math.floor((b + 8) / 25);
    const g = Math.floor((b - f + 1) / 3);
    const h = (19 * a + b - d - g + 15) % 30;
    const i = Math.floor(c / 4), k = c % 4;
    const l = (32 + 2 * e + 2 * i - h - k) % 7;
    const m = Math.floor((a + 11 * h + 22 * l) / 451);
    const month = Math.floor((h + l - 7 * m + 114) / 31);
    const day = ((h + l - 7 * m + 114) % 31) + 1;
    return new Date(y, month - 1, day);
  }

  function holidaysFor(y) {
    if (Config.calendarHolidays !== "BR") return {};
    const out = {};
    const add = (d, name) => { out[d.getMonth() + "-" + d.getDate()] = name; };
    const e = root.easter(y);
    const rel = n => new Date(e.getFullYear(), e.getMonth(), e.getDate() + n);
    add(new Date(y, 0, 1),   "Confraternização Universal");
    add(rel(-48),            "Carnaval");
    add(rel(-47),            "Carnaval");
    add(rel(-2),             "Sexta-feira Santa");
    add(e,                   "Páscoa");
    add(new Date(y, 3, 21),  "Tiradentes");
    add(new Date(y, 4, 1),   "Dia do Trabalho");
    add(rel(60),             "Corpus Christi");
    add(new Date(y, 8, 7),   "Independência do Brasil");
    add(new Date(y, 9, 12),  "Nossa Senhora Aparecida");
    add(new Date(y, 10, 2),  "Finados");
    add(new Date(y, 10, 15), "Proclamação da República");
    if (y >= 2024) add(new Date(y, 10, 20), "Consciência Negra");
    add(new Date(y, 11, 25), "Natal");
    return out;
  }

  // Cached per displayed year (plus neighbours for the leading/trailing days).
  readonly property var _holidays: {
    const all = {};
    for (const y of [displayYear - 1, displayYear, displayYear + 1])
      all[y] = holidaysFor(y);
    return all;
  }

  function holiday(d) {
    const h = root._holidays[d.getFullYear()];
    return h ? (h[d.getMonth() + "-" + d.getDate()] || "") : "";
  }

  // ── Navigation ───────────────────────────────────────────────
  function shiftMonth(delta) {
    root._slideDir = delta;
    let m = displayMonth + delta, y = displayYear;
    if (m < 0)  { m = 11; y -= 1; }
    if (m > 11) { m = 0;  y += 1; }
    displayMonth = m;
    displayYear = y;
    slide.restart();
  }

  function goToday() {
    if (viewingCurrent) return;
    const forward = displayYear < today.getFullYear()
      || (displayYear === today.getFullYear() && displayMonth < today.getMonth());
    root._slideDir = forward ? 1 : -1;
    displayYear = today.getFullYear();
    displayMonth = today.getMonth();
    root.selected = null;
    slide.restart();
  }

  function relativeDays(d) {
    const a = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    const b = new Date(d.getFullYear(), d.getMonth(), d.getDate());
    const n = Math.round((b - a) / 86400000);
    if (n === 0)  return "today";
    if (n === 1)  return "tomorrow";
    if (n === -1) return "yesterday";
    return n > 0 ? "in " + n + " days" : Math.abs(n) + " days ago";
  }

  WheelHandler {
    onWheel: (event) => {
      if (event.angleDelta.y > 0)      root.shiftMonth(-1);
      else if (event.angleDelta.y < 0) root.shiftMonth(1);
    }
  }

  ColumnLayout {
    id: layout
    width: parent.width
    spacing: 8

    // — Today —
    RowLayout {
      Layout.fillWidth: true
      spacing: 10

      StyledText {
        text: root.today.getDate()
        font.pixelSize: Config.fontSize + 18
        font.weight: Font.Medium
        color: root.colBright
      }

      ColumnLayout {
        spacing: 0
        StyledText {
          text: root.cap(root.loc.dayName(root.today.getDay(), Locale.LongFormat))
          font.pixelSize: Config.fontSize
          font.weight: Font.Medium
          color: root.colFg
        }
        StyledText {
          text: root.cap(root.loc.monthName(root.today.getMonth(), Locale.LongFormat))
                + " " + root.today.getFullYear()
          font.pixelSize: Config.fontSize - 3
          color: root.colAccent
        }
      }

      Item { Layout.fillWidth: true }

      StyledText {
        Layout.alignment: Qt.AlignTop
        text: "W" + root.isoWeek(root.today)
        font.pixelSize: Config.fontSize - 4
        font.letterSpacing: 1.2
        color: root.colDim
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Config.darkMode ? Qt.rgba(1,1,1,0.07) : Qt.rgba(0,0,0,0.07)
    }

    // — Month navigation —
    RowLayout {
      Layout.fillWidth: true
      spacing: 0

      component NavButton: Rectangle {
        id: nav
        property string glyph
        signal clicked()
        implicitWidth: 24
        implicitHeight: 24
        radius: Config.radius
        color: navMa.containsMouse ? root.colHover : "transparent"
        Behavior on color { CAnim {} }

        StyledText {
          anchors.centerIn: parent
          text: nav.glyph
          font.pixelSize: 16
          color: navMa.containsMouse ? root.colFg : root.colAccent
        }
        MouseArea {
          id: navMa
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: nav.clicked()
        }
      }

      NavButton { glyph: "‹"; onClicked: root.shiftMonth(-1) }

      Item {
        Layout.fillWidth: true
        implicitHeight: 24

        StyledText {
          anchors.centerIn: parent
          text: root.cap(root.loc.monthName(root.displayMonth, Locale.LongFormat)) + "  " + root.displayYear
          color: root.colFg
          font.pixelSize: Config.fontSize - 1
          font.weight: Font.Medium
        }

        // Back-to-today hint, only away from the current month.
        StyledText {
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          visible: !root.viewingCurrent
          text: "today"
          font.pixelSize: Config.fontSize - 5
          font.letterSpacing: 1.2
          color: todayMa.containsMouse ? root.colFg : root.colDim
        }

        MouseArea {
          id: todayMa
          anchors.fill: parent
          hoverEnabled: !root.viewingCurrent
          enabled: !root.viewingCurrent
          cursorShape: Qt.PointingHandCursor
          onClicked: root.goToday()
        }
      }

      NavButton { glyph: "›"; onClicked: root.shiftMonth(1) }
    }

    // — Grid (weekday header + 6 weeks), slides on month change —
    Item {
      id: gridClip
      Layout.fillWidth: true
      Layout.preferredHeight: gridCol.implicitHeight
      clip: true

      ColumnLayout {
        id: gridCol
        width: parent.width
        spacing: 2

        Row {
          Item { width: root.weekColW; height: 18 }
          Repeater {
            model: 7
            StyledText {
              required property int index
              readonly property int dow: (root.firstDow + index) % 7
              width: root.cellW
              height: 18
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              text: root.loc.dayName(dow, Locale.NarrowFormat).toUpperCase()
              color: root.colDim
              opacity: (dow === 0 || dow === 6) ? 0.6 : 1.0
              font.pixelSize: Config.fontSize - 5
              font.letterSpacing: 1
            }
          }
        }

        Item {
          id: weeks
          Layout.fillWidth: true
          Layout.preferredHeight: 6 * (root.cellH + 2)

          SequentialAnimation {
            id: slide
            PropertyAction { target: weeks; property: "x"; value: root._slideDir * 24 }
            PropertyAction { target: weeks; property: "opacity"; value: 0 }
            ParallelAnimation {
              Anim { target: weeks; property: "x"; to: 0; duration: Motion.fastSpatialDuration; curve: Motion.decel }
              Anim { target: weeks; property: "opacity"; to: 1; duration: Motion.effectsDuration; curve: Motion.effects }
            }
          }

          Column {
            spacing: 2

            Repeater {
              model: 6

              Row {
                id: week
                required property int index
                // The row's middle day picks its ISO week, which stays right
                // when the locale starts weeks on Sunday.
                readonly property var midWeek: root.cellDate(index * 7 + 3)

                StyledText {
                  width: root.weekColW
                  height: root.cellH
                  verticalAlignment: Text.AlignVCenter
                  text: root.isoWeek(week.midWeek)
                  font.pixelSize: Config.fontSize - 6
                  color: root.colMuted
                }

                Repeater {
                  model: 7

                  Item {
                    id: dayCell
                    required property int index
                    readonly property var date: root.cellDate(week.index * 7 + index)
                    readonly property bool inMonth: date.getMonth() === root.displayMonth
                    readonly property bool isToday: root.sameDay(date, root.today)
                    readonly property bool isSelected: root.sameDay(date, root.selected)
                    readonly property bool isWeekend: date.getDay() === 0 || date.getDay() === 6
                    readonly property string holiday: root.holiday(date)

                    width: root.cellW
                    height: root.cellH

                    Rectangle {
                      anchors.centerIn: parent
                      width: Math.min(parent.width, parent.height) - 2
                      height: width
                      radius: width / 2
                      color: dayCell.isToday ? root.colToday
                           : (cellMa.containsMouse ? root.colHover : "transparent")
                      border.width: dayCell.isSelected && !dayCell.isToday ? 1 : 0
                      border.color: root.colAccent
                      Behavior on color { CAnim {} }
                    }

                    StyledText {
                      anchors.centerIn: parent
                      text: dayCell.date.getDate()
                      font.pixelSize: Config.fontSize - 2
                      font.weight: dayCell.isToday ? Font.Medium : Font.Normal
                      color: dayCell.isToday ? root.colOnToday
                           : !dayCell.inMonth ? root.colMuted
                           : (dayCell.holiday || dayCell.isWeekend) ? root.colAccent
                           : root.colFg
                      opacity: !dayCell.inMonth ? 0.6 : 1
                    }

                    // Holiday marker
                    Rectangle {
                      visible: dayCell.holiday.length > 0
                      anchors.horizontalCenter: parent.horizontalCenter
                      anchors.bottom: parent.bottom
                      anchors.bottomMargin: 2
                      width: 3
                      height: 3
                      radius: 1.5
                      color: dayCell.isToday ? root.colOnToday : root.colAccent
                      opacity: dayCell.inMonth ? 1 : 0.5
                    }

                    MouseArea {
                      id: cellMa
                      anchors.fill: parent
                      hoverEnabled: true
                      cursorShape: Qt.PointingHandCursor
                      onClicked: {
                        if (!dayCell.inMonth)
                          root.shiftMonth(dayCell.date < new Date(root.displayYear, root.displayMonth, 1) ? -1 : 1);
                        root.selected = root.sameDay(dayCell.date, root.selected) ? null : dayCell.date;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // — Selected day readout —
    RowLayout {
      Layout.fillWidth: true
      visible: root.selected !== null
      spacing: 6

      StyledText {
        text: root.selected ? root.selected.getDate() + " "
              + root.loc.monthName(root.selected.getMonth(), Locale.ShortFormat) : ""
        font.pixelSize: Config.fontSize - 3
        font.weight: Font.Medium
        color: root.colFg
      }
      StyledText {
        text: root.selected ? root.relativeDays(root.selected) : ""
        font.pixelSize: Config.fontSize - 3
        color: root.colAccent
      }
      StyledText {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignRight
        text: root.selected ? root.holiday(root.selected) : ""
        elide: Text.ElideRight
        font.pixelSize: Config.fontSize - 4
        color: root.colDim
      }
    }
  }
}
