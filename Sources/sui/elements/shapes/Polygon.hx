package sui.elements.shapes;

import kha.Color;
import kha.math.Vector2;
// sui
import sui.SUI;

@:structInit
class Polygon extends Element {
	public var color:Color = Color.White;
	public var vertices:Array<Vector2> = [{}];

	override function draw() {
		applyTransformation();
		SUI.graphics.color = color;

		var iterator = vertices.iterator();

		if (!iterator.hasNext())
			return;
		var v0 = iterator.next();

		if (!iterator.hasNext())
			return;
		var v1 = iterator.next();

		while (iterator.hasNext()) {
			var v2 = iterator.next();
			SUI.graphics.fillTriangle(v0.x + x, v0.y + y, v1.x + x, v1.y + y, v2.x + x, v2.y + y);
			v1 = v2;
		}

		popTransformation();
	}
}
