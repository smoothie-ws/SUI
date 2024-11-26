package sui.elements.shapes;

import kha.Canvas;
// sui
import sui.effects.Border;

class SimpleRectangle extends SimpleDrawableElement {
	public var border:Border = {};

	override inline function simpleDraw(target:Canvas) {
		var x = left.position;
		var y = top.position;
		var width = right.position - x;
		var height = bottom.position - y;

		target.g2.color = color;
		target.g2.fillRect(x, y, width, height);
		target.g2.color = border.color;
		target.g2.drawRect(x, y, width, height, border.width);
	}
}
