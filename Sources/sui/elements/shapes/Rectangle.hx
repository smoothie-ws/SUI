package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.elements.batches.RectBatch;

class Rectangle extends Element {
	override inline function get_batchType() {
		return RectBatch;
	}

	inline function setLeft(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;

			b.rectBounds[instanceID * 4 + 0] = value;
		}
	}

	inline function setTop(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;

			b.rectBounds[instanceID * 4 + 1] = value;
		}
	}

	inline function setRight(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;

			b.rectBounds[instanceID * 4 + 2] = value;
		}
	}

	inline function setBottom(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;

			b.rectBounds[instanceID * 4 + 3] = value;
		}
	}

	override public function new() {
		super();
		left.addListener(setLeft);
		top.addListener(setTop);
		right.addListener(setRight);
		bottom.addListener(setBottom);
	}

	@:isVar public var color(get, set):Color = Color.White;
	@:isVar public var softness(get, set):FastFloat = 1;
	@:isVar public var radius(get, set):FastFloat = 0;

	inline function get_color() {
		return color;
	}

	inline function set_color(value:Color) {
		color = value;

		if (batch != null) {
			var b:RectBatch = cast batch;
			var o = finalOpacity;
			b.rectColors[instanceID * 4 + 0] = color.R;
			b.rectColors[instanceID * 4 + 1] = color.G;
			b.rectColors[instanceID * 4 + 2] = color.B;
			b.rectColors[instanceID * 4 + 3] = color.A * o;
		}

		return color;
	}

	inline function get_softness() {
		return softness;
	}

	inline function set_softness(value:FastFloat) {
		softness = value;

		if (batch != null) {
			var b:RectBatch = cast batch;
			b.rectAttrib[instanceID * 2 + 1] = softness;
		}

		return softness;
	}

	inline function get_radius() {
		return radius;
	}

	inline function set_radius(value:FastFloat) {
		radius = value;

		if (batch != null) {
			var b:RectBatch = cast batch;
			b.rectAttrib[instanceID * 2 + 0] = radius;
		}
		return radius;
	}
}
