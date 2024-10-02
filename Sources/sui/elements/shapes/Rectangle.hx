package sui.elements.shapes;

import kha.FastFloat;
// sui
import sui.SUI;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;

	override function draw() {
		SUI.graphics.fillRect(x, y, finalW, finalH);
	}
}
