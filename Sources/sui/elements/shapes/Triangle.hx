package sui.elements.shapes;

import kha.FastFloat;
import kha.math.Vector2;
// sui
import sui.core.Element;

@:structInit
class Triangle extends Element {
	public var v1:Vector2 = {x: 0., y: 0.}
	public var v2:Vector2 = {x: 0., y: 0.}
	public var v3:Vector2 = {x: 0., y: 0.}

	override function draw() {
		final x1:FastFloat = offsetX + v1.x;
		final y1:FastFloat = offsetY + v1.y;
		final x2:FastFloat = offsetX + v2.x;
		final y2:FastFloat = offsetY + v2.y;
		final x3:FastFloat = offsetX + v3.x;
		final y3:FastFloat = offsetY + v3.y;
		SUI.rawbuffers[0].g2.fillTriangle(x1, y1, x2, y2, x3, y3);
	}
}
