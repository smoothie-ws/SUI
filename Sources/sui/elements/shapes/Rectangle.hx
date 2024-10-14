package sui.elements.shapes;

import sui.core.graphics.Painters;
import kha.FastFloat;
// sui
import sui.core.Element;

using sui.core.graphics.GraphicsExtension;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;
	public var smoothness:FastFloat = 1.;

	override function draw() {
		Painters.Rect.fillRect(backbuffer, 0., 0., finalW, finalH, color, radius, smoothness);
	}
}
