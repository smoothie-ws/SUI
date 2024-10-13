package sui.elements.shapes;

import kha.FastFloat;
// sui
import sui.core.Element;

using sui.core.graphics.GraphicsExtension;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;

	override function draw() {
		var s = Std.int(radius);

		backbuffer.g2.fillCircle(radius, radius, radius, s);
		backbuffer.g2.fillCircle(finalW - radius, radius, radius, s);
		backbuffer.g2.fillCircle(radius, finalH - radius, radius, s);
		backbuffer.g2.fillCircle(finalW - radius, finalH - radius, radius, s);

		backbuffer.g2.fillRect(radius, 0., finalW - radius * 2, finalH);
		backbuffer.g2.fillRect(0., radius, finalW, finalH - radius * 2);

		// border
		
		backbuffer.g2.color = kha.Color.fromValue(border.color);
		backbuffer.g2.opacity = border.opacity;

		backbuffer.g2.drawArc(radius, radius, radius, Math.PI, 1.5 * Math.PI, border.width);
		backbuffer.g2.drawArc(finalW - radius, radius, radius, 1.5 * Math.PI, 2 * Math.PI, border.width);
		backbuffer.g2.drawArc(radius, finalH - radius, radius, 0.5 * Math.PI, Math.PI, border.width);
		backbuffer.g2.drawArc(finalW - radius, finalH - radius, radius, 0, 0.5 * Math.PI, border.width);

		backbuffer.g2.drawLine(radius, 0., finalW - radius, 0., border.width);
		backbuffer.g2.drawLine(radius, finalH, finalW - radius, finalH, border.width);
		backbuffer.g2.drawLine(0., radius, 0., finalH - radius, border.width);
		backbuffer.g2.drawLine(finalW, radius, finalW, finalH - radius, border.width);
	}
}
