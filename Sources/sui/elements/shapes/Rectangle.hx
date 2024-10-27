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
		Painters.Rect.dims.x = offsetX;
		Painters.Rect.dims.y = offsetY;
		Painters.Rect.dims.z = finalW;
		Painters.Rect.dims.w = finalH;
		Painters.Rect.color = color;
		Painters.Rect.radius = radius;
		Painters.Rect.smoothness = smoothness;
		
		Painters.Rect.apply(SUI.rawbuffers[0]);
	}
}
