package sui.elements.shapes;

import kha.FastFloat;
import kha.math.Vector2;
// sui
import sui.SUI;

@:structInit
class Path extends Element {
	public var lineWidth:FastFloat = 1.;
	public var start:Vector2 = {x: 0., y: 0.}
	public var end:Vector2 = {x: 0., y: 0.}

	override function draw() {
		final x1:FastFloat = finalX + start.x;
		final y1:FastFloat = finalY + start.y;
		final x2:FastFloat = finalX + end.x;
		final y2:FastFloat = finalY + end.y;
		SUI.graphics.drawLine(x1, y1, x2, y2, lineWidth);
	}
}
