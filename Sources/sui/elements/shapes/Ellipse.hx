package sui.elements.shapes;

import kha.FastFloat;
// sui
import sui.core.Element;
import sui.core.graphics.Painters;

@:structInit
class Ellipse extends Element {
	public var smoothness:FastFloat = 2.;

	override function draw() {
		Painters.Ellipse.fillEllipse(SUI.rawbuffers[0], offsetX, offsetY, finalW, finalH, color, smoothness);
	}
}
