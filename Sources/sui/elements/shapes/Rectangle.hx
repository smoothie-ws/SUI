package sui.elements.shapes;

import kha.FastFloat;
// sui
import sui.core.Element;
import sui.core.graphics.Painters;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;
	public var smoothness:FastFloat = 2.;

	override function draw() {
		Painters.Rect.fillRect(SUI.rawbackbuffer, offsetX, offsetY, finalW, finalH, color, radius, smoothness);
	}
}
