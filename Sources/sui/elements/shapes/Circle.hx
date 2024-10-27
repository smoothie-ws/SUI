package sui.elements.shapes;

// sui
import sui.core.Element;
import sui.core.graphics.Painters;

@:structInit
class Circle extends Element {
	override function draw() {
		Painters.Ellipse.dims.x = offsetX;
		Painters.Ellipse.dims.y = offsetY;
		Painters.Ellipse.dims.z = finalW;
		Painters.Ellipse.dims.w = finalH;
		Painters.Ellipse.color = color;

		Painters.Ellipse.apply(SUI.rawbuffers[0]);
	}
}
