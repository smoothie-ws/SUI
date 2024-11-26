package sui.elements;

import kha.Color;
import kha.Canvas;
import kha.FastFloat;

class DrawableElement extends Element {
	public var visible:Bool = true;
	public var opacity:FastFloat = 1;
	public var finalOpacity(get, never):FastFloat;
	@:isVar public var color(default, set):Color = Color.White;

	function set_color(value:Color) {
		color = value;
		return color;
	}

	function get_finalOpacity():FastFloat {
		if (parent is DrawableElement)
			return opacity * cast(parent, DrawableElement).finalOpacity;
		return opacity;
	}

	public function draw(target:Canvas) {}
}
