package sui.elements.shapes;

import kha.FastFloat;
// sui
import sui.core.Element;
import sui.core.graphics.Painters;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;
	public var topLeftRadius:FastFloat = Math.NaN;
	public var topRightRadius:FastFloat = Math.NaN;
	public var bottomLeftRadius:FastFloat = Math.NaN;
	public var bottomRightRadius:FastFloat = Math.NaN;

	override function draw() {
		Painters.Rect.color = color;
		Painters.Rect.dims.x = offsetX;
		Painters.Rect.dims.y = offsetY;
		Painters.Rect.dims.z = finalW;
		Painters.Rect.dims.w = finalH;
		Painters.Rect.radiuses.x = Math.isNaN(topLeftRadius) ? radius : topLeftRadius;
		Painters.Rect.radiuses.y = Math.isNaN(topRightRadius) ? radius : topRightRadius;
		Painters.Rect.radiuses.z = Math.isNaN(bottomLeftRadius) ? radius : bottomLeftRadius;
		Painters.Rect.radiuses.w = Math.isNaN(bottomRightRadius) ? radius : bottomRightRadius;

		SUI.rawbuffer.g2.scissor(Std.int(offsetX), Std.int(offsetY), Std.int(finalW), Std.int(finalH));
		Painters.Rect.apply(SUI.rawbuffer);
		SUI.rawbuffer.g2.disableScissor();
	}
}
