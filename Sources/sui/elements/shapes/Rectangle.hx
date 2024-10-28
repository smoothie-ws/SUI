package sui.elements.shapes;

import kha.Canvas;
import kha.FastFloat;
// sui
import sui.core.Element;
import sui.core.graphics.Painters;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;
	public var topLeftRadius:FastFloat = null;
	public var topRightRadius:FastFloat = null;
	public var bottomLeftRadius:FastFloat = null;
	public var bottomRightRadius:FastFloat = null;

	override function draw(buffer:Canvas) {
		Painters.Rect.color = color;
		Painters.Rect.dims.x = offsetX;
		Painters.Rect.dims.y = offsetY;
		Painters.Rect.dims.z = finalW;
		Painters.Rect.dims.w = finalH;
		Painters.Rect.radiuses.x = topLeftRadius == null ? radius : topLeftRadius;
		Painters.Rect.radiuses.y = topRightRadius == null ? radius : topRightRadius;
		Painters.Rect.radiuses.z = bottomLeftRadius == null ? radius : bottomLeftRadius;
		Painters.Rect.radiuses.w = bottomRightRadius == null ? radius : bottomRightRadius;

		Painters.Rect.apply(buffer);
	}
}
