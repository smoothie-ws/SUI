package sui.elements.shapes;

import kha.FastFloat;
// sui
import sui.core.Element;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;

	override function draw() {
		backbuffer.g2.fillRect(0., 0., finalW, finalH);
	}
}
