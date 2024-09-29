package sui.elements.shapes;

import kha.FastFloat;
import kha.math.Vector2;
// sui
import sui.SUI;

@:structInit
class Triangle extends Element {
	public var v1:Vector2 = {x: 0., y: 0.}
	public var v2:Vector2 = {x: 0., y: 0.}
	public var v3:Vector2 = {x: 0., y: 0.}

	override function draw() {
		final x1:FastFloat = finalX + v1.x;
		final y1:FastFloat = finalY + v1.y;
		final x2:FastFloat = finalX + v2.x;
		final y2:FastFloat = finalY + v2.y;
		final x3:FastFloat = finalX + v3.x;
		final y3:FastFloat = finalY + v3.y;
		SUI.graphics.fillTriangle(x1, y1, x2, y2, x3, y3);
	}
}
