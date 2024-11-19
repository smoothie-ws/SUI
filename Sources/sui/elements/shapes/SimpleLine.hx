package sui.elements.shapes;

import kha.Canvas;
import kha.FastFloat;
import kha.math.FastVector2;

@:structInit
class SimpleLine extends DrawableElement {
	public var lineWidth:FastFloat = 1;
	public var start:FastVector2 = {x: 0, y: 0}
	public var end:FastVector2 = {x: 0, y: 0}

	override inline function draw(target:Canvas) {
		var x = left.position;
		var y = right.position;
		
		target.g2.color = color;
		target.g2.drawLine(x + start.x, y + start.y, x + end.x, y + end.y, lineWidth);
	}
}
