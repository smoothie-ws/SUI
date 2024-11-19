package sui.elements.shapes;

import kha.Canvas;
import kha.FastFloat;
// sui
import sui.effects.Border;

using sui.core.graphics.GraphicsExtension;

class SimpleCircle extends DrawableElement {
	public var border:Border = {};
	public var radius:FastFloat = 0;
	public var segments:Int = 64;

	override inline function draw(target:Canvas) {
		var x = left.position;
		var y = top.position;

		target.g2.color = color;
		target.g2.fillCircle(x, y, radius, segments);
		target.g2.color = border.color;
		target.g2.drawCircle(x, y, radius, border.width, segments);
	}
}
