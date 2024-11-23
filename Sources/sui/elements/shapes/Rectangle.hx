package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.effects.Gradient;
import sui.elements.batches.RectBatch;

class Rectangle extends Element {
	override inline function get_batchType() {
		return RectBatch;
	}

	override public function new() {
		super();
		SUI.scene.addChild(this);
	}

	@:isVar public var color(get, set):Color = Color.White;
	@:isVar public var softness(get, set):FastFloat = 1;
	@:isVar public var radius(get, set):FastFloat = 0;
	@:isVar public var gradient(get, set):Gradient = null;

	inline function get_color() {
		return color;
	}

	inline function set_color(value:Color) {
		color = value;

		var b = cast batch;
		var o = finalOpacity;
		b.gradColors[instanceID * 4 + 0] = color.R;
		b.gradColors[instanceID * 4 + 1] = color.G;
		b.gradColors[instanceID * 4 + 2] = color.B;
		b.gradColors[instanceID * 4 + 3] = color.A * o;
		b.gradColors[instanceID * 4 + 4] = color.R;
		b.gradColors[instanceID * 4 + 5] = color.G;
		b.gradColors[instanceID * 4 + 6] = color.B;
		b.gradColors[instanceID * 4 + 7] = color.A * o;

		return color;
	}

	inline function get_softness() {
		return softness;
	}

	inline function set_softness(value:FastFloat) {
		softness = value;

		var b = cast batch;
		b.rectAttrib[instanceID * 2 + 1] = softness;

		return softness;
	}

	inline function get_radius() {
		return radius;
	}

	inline function set_radius(value:FastFloat) {
		radius = value;

		var b = cast batch;
		b.rectAttrib[instanceID * 2 + 0] = radius;

		return radius;
	}

	inline function get_gradient() {
		return gradient;
	}

	inline function set_gradient(value:Gradient) {
		gradient = value;

		var b = cast batch;
		var o = finalOpacity;
		b.gradColors[instanceID * 4 + 0] = gradient.end.R;
		b.gradColors[instanceID * 4 + 1] = gradient.end.G;
		b.gradColors[instanceID * 4 + 2] = gradient.end.B;
		b.gradColors[instanceID * 4 + 3] = gradient.end.A * o;
		b.gradColors[instanceID * 4 + 4] = gradient.start.R;
		b.gradColors[instanceID * 4 + 5] = gradient.start.G;
		b.gradColors[instanceID * 4 + 6] = gradient.start.B;
		b.gradColors[instanceID * 4 + 7] = gradient.start.A * o;
		b.gradAttrib[instanceID * 4 + 0] = gradient.alignByElement ? 1.0 : 2.0;
		b.gradAttrib[instanceID * 4 + 1] = gradient.angle;
		b.gradAttrib[instanceID * 4 + 2] = gradient.position;
		b.gradAttrib[instanceID * 4 + 3] = gradient.scale;

		return gradient;
	}

	override inline function set_x(value:FastFloat):FastFloat {
		var b = cast batch;
		b.rectBounds[instanceID * 4 + 0] = value;
		anchors.left.position = x;
		return value;
	}

	override inline function set_y(value:FastFloat):FastFloat {
		var b = cast batch;
		b.rectBounds[instanceID * 4 + 1] = value;
		anchors.top.position = y;
		return value;
	}

	override inline function set_width(value:FastFloat):FastFloat {
		var b = cast batch;
		b.rectBounds[instanceID * 4 + 2] = value;
		anchors.right.position = x + value;
		return value;
	}

	override inline function set_height(value:FastFloat):FastFloat {
		var b = cast batch;
		b.rectBounds[instanceID * 4 + 3] = value;
		anchors.bottom.position = y + value;
		return value;
	}
}
