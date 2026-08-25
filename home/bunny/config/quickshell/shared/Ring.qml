import QtQuick

Item {
  id: root
  property real value: 0            // 0..1
  property color trackColor: Qt.rgba(1, 1, 1, 0.08)
  property color fillColor:  Qt.rgba(1, 1, 1, 0.60)
  property int strokeWidth: 3

  onValueChanged: canvas.requestPaint()
  onTrackColorChanged: canvas.requestPaint()
  onFillColorChanged: canvas.requestPaint()
  onStrokeWidthChanged: canvas.requestPaint()

  Canvas {
    id: canvas
    anchors.fill: parent
    onPaint: {
      const ctx = getContext("2d");
      const w = width, h = height;
      const cx = w / 2, cy = h / 2;
      const r = Math.min(w, h) / 2 - root.strokeWidth / 2;

      ctx.reset();
      ctx.lineCap = "round";

      // Track
      ctx.beginPath();
      ctx.arc(cx, cy, r, 0, Math.PI * 2);
      ctx.strokeStyle = root.trackColor;
      ctx.lineWidth = root.strokeWidth;
      ctx.stroke();

      // Fill arc (clockwise from 12 o'clock)
      const v = Math.max(0, Math.min(1, root.value));
      if (v > 0) {
        ctx.beginPath();
        const start = -Math.PI / 2;
        const end   = start + Math.PI * 2 * v;
        ctx.arc(cx, cy, r, start, end);
        ctx.strokeStyle = root.fillColor;
        ctx.lineWidth = root.strokeWidth;
        ctx.stroke();
      }
    }
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
  }
}
