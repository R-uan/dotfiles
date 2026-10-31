import QtQuick

// Filled line chart of 0-100 values, oldest first, newest on the right edge.
// `capacity` fixes the x spacing so the line scrolls in from the right
// instead of stretching while the history fills up.
Item {
  id: root
  property var values: []
  property int capacity: 40
  property color lineColor: Qt.rgba(1, 1, 1, 0.60)
  property real fillAlpha: 0.12
  property real lineWidth: 1.5

  onValuesChanged: canvas.requestPaint()
  onLineColorChanged: canvas.requestPaint()

  Canvas {
    id: canvas
    anchors.fill: parent
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
      const ctx = getContext("2d");
      ctx.reset();
      const vals = root.values || [];
      if (vals.length < 2) return;

      const w = width, h = height;
      const step = w / Math.max(1, root.capacity - 1);
      const x0 = w - (vals.length - 1) * step;
      const pad = root.lineWidth;
      const yOf = v => pad + (h - 2 * pad) * (1 - Math.max(0, Math.min(100, v)) / 100);

      ctx.beginPath();
      ctx.moveTo(x0, yOf(vals[0]));
      for (let i = 1; i < vals.length; i++)
        ctx.lineTo(x0 + i * step, yOf(vals[i]));

      ctx.lineWidth = root.lineWidth;
      ctx.lineJoin = "round";
      ctx.strokeStyle = root.lineColor;
      ctx.stroke();

      ctx.lineTo(w, h);
      ctx.lineTo(x0, h);
      ctx.closePath();
      const grad = ctx.createLinearGradient(0, 0, 0, h);
      const c = root.lineColor;
      grad.addColorStop(0, Qt.rgba(c.r, c.g, c.b, root.fillAlpha));
      grad.addColorStop(1, Qt.rgba(c.r, c.g, c.b, 0));
      ctx.fillStyle = grad;
      ctx.fill();
    }
  }
}
