import QtQuick
import Quickshell

pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property var time: {
        id: clock
        Qt.formatDateTime(clock.date, "ddd,  MMM d  ♥  HH:mm")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
