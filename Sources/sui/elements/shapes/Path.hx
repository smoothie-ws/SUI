package sui.elements.shapes;

import kha.Canvas;
import kha.FastFloat;
import kha.math.Vector2;
// sui
import sui.core.Element;

@:structInit
class Path extends Element {
	public var lineWidth:FastFloat = 1.;
	public var start:Vector2 = {x: 0., y: 0.}
	public var end:Vector2 = {x: 0., y: 0.}

	override function draw(buffer:Canvas) {
		final x1:FastFloat = offsetX + start.x;
		final y1:FastFloat = offsetY + start.y;
		final x2:FastFloat = offsetX + end.x;
		final y2:FastFloat = offsetY + end.y;
		buffer.g2.drawLine(x1, y1, x2, y2, lineWidth);
	}
}
