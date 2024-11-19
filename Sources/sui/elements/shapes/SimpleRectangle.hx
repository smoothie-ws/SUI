package sui.elements.shapes;

import kha.Canvas;

class SimpleRectangle extends DrawableElement {
	override public inline function draw(target:Canvas) {
		var x = left.position;
		var y = top.position;
		var width = right.position - x;
		var height = bottom.position - y;

		target.g2.color = color;
		target.g2.fillRect(x, y, width, height);
	}
}
