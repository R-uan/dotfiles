pragma Singleton
import QtQuick

// Motion tokens, after Material 3 "expressive" (the curves caelestia and
// end-4's illogical-impulse use). Spatial curves overshoot slightly and are
// for size/position; effects curves don't and are for opacity/colour.
// Leaving uses accel so nothing bounces past zero on the way out.
QtObject {
  readonly property var spatial:     [0.38, 1.21, 0.22, 1.00, 1, 1]
  readonly property var fastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1]
  readonly property var effects:     [0.34, 0.80, 0.34, 1.00, 1, 1]
  readonly property var decel:       [0.05, 0.70, 0.10, 1.00, 1, 1]
  readonly property var accel:       [0.30, 0.00, 0.80, 0.15, 1, 1]

  readonly property int spatialDuration:     500
  readonly property int fastSpatialDuration: 350
  readonly property int effectsDuration:     200
  readonly property int exitDuration:        200
}
