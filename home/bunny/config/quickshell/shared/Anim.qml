import qs.config

import QtQuick

// NumberAnimation on the shared motion curve. Defaults to the spatial
// (slight overshoot) curve; set `curve`/`duration` for effects or exits.
NumberAnimation {
  property var curve: Motion.spatial
  duration: Motion.spatialDuration
  easing.type: Easing.BezierSpline
  easing.bezierCurve: curve
}
