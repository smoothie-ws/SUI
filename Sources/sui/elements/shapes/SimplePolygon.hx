package sui.elements.shapes;

import kha.Canvas;
import kha.math.Vector2;
// sui
import sui.effects.Border;

using sui.core.graphics.GraphicsExtension;

@:structInit
class Polygon extends SimpleDrawableElement {
	public var border:Border = {};
	public var vertices:Array<Vector2> = [{}];

	override inline function simpleDraw(target:Canvas) {
		var x = left.position;
		var y = top.position;
		
		target.g2.color = color;
		target.g2.fillPolygon(x, y, vertices);
		target.g2.color = border.color;
		target.g2.drawPolygon(x, y, vertices, border.width);
	}
}
