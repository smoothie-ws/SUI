package sui.elements.shapes;

import kha.Canvas;
import kha.FastFloat;
// sui
import sui.effects.Border;

using sui.core.graphics.GraphicsExtension;

@:structInit
class SimpleArc extends DrawableElement {
	public var border:Border = {};
	public var radius:FastFloat = 0;
	public var sAngle:FastFloat = 90;
	public var eAngle:FastFloat = 0;
	public var clockwise:Bool = false;
	public var segments:Int = 16;

	override inline function draw(target:Canvas) {
		var x = left.position;
		var y = top.position;

		target.g2.color = color;
		target.g2.fillArc(x, y, radius, sAngle, eAngle, !clockwise, segments);
		target.g2.color = border.color;
		target.g2.drawArc(x, y, radius, sAngle, eAngle, border.width, !clockwise, segments);
	}
}
