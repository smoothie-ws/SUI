package sui.elements.shapes;

import kha.Canvas;
import kha.math.FastVector2;

@:structInit
class Polygon extends DrawableElement {
	public var vertices:Array<FastVector2> = [{}];

	override function draw(target:Canvas) {
		var iterator = vertices.iterator();

		if (!iterator.hasNext())
			return;
		var v0 = iterator.next();

		if (!iterator.hasNext())
			return;
		var v1 = iterator.next();

		target.g2.color = color;
		while (iterator.hasNext()) {
			var v2 = iterator.next();
			target.g2.fillTriangle(v0.x + x, v0.y + y, v1.x + x, v1.y + y, v2.x + x, v2.y + y);
			v1 = v2;
		}
	}
}
