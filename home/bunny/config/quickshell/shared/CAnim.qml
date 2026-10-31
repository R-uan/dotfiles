import qs.config

import QtQuick

// ColorAnimation on the shared effects curve.
ColorAnimation {
  duration: Motion.effectsDuration
  easing.type: Easing.BezierSpline
  easing.bezierCurve: Motion.effects
}
