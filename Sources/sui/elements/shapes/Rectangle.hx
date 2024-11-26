package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.elements.batches.RectBatch;

class Rectangle extends Element {
	@:isVar public var color(default, set):Color = Color.White;
	@:isVar public var softness(default, set):FastFloat = 1;
	@:isVar public var radius(default, set):FastFloat = 0;

	override inline function get_batchType() {
		return RectBatch;
	}

	override public function new() {
		super();
		left.addPositionListener(setLeft);
		top.addPositionListener(setTop);
		right.addPositionListener(setRight);
		bottom.addPositionListener(setBottom);
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

	inline function set_softness(value:FastFloat) {
		softness = value;

		if (batch != null) {
			var b:RectBatch = cast batch;
			b.rectAttrib[instanceID * 2 + 1] = softness;
		}

		return softness;
	}

	inline function set_radius(value:FastFloat) {
		radius = value;

		if (batch != null) {
			var b:RectBatch = cast batch;
			b.rectAttrib[instanceID * 2 + 0] = radius;
		}
		return radius;
	}

	override inline function set_scaleX(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = value / scaleX;

			var vert = b.vertices.lock();
			vert[instanceID * 20 + 0] *= d;
			vert[instanceID * 20 + 5] *= d;
			vert[instanceID * 20 + 10] *= d;
			vert[instanceID * 20 + 15] *= d;
			b.vertices.unlock();
		}
		scaleX = value;
		return value;
	}

	override inline function set_scaleY(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = value / scaleY;

			var vert = b.vertices.lock();
			vert[instanceID * 20 + 1] *= d;
			vert[instanceID * 20 + 6] *= d;
			vert[instanceID * 20 + 11] *= d;
			vert[instanceID * 20 + 16] *= d;
			b.vertices.unlock();
		}
		scaleY = value;
		return value;
	}

	override inline function set_rotation(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = value - rotation;
			var rotRad = Math.PI * d / 180;
			var rotCos = Math.cos(rotRad);
			var rotSin = Math.sin(rotRad);

			var vert = b.vertices.lock();

			var _x = vert[instanceID * 20 + 0];
			var _y = vert[instanceID * 20 + 1];
			vert[instanceID * 20 + 0] = _x * rotCos - _y * rotSin;
			vert[instanceID * 20 + 1] = _x * rotSin + _y * rotCos;

			_x = vert[instanceID * 20 + 5];
			_y = vert[instanceID * 20 + 6];
			vert[instanceID * 20 + 5] = _x * rotCos - _y * rotSin;
			vert[instanceID * 20 + 6] = _x * rotSin + _y * rotCos;

			_x = vert[instanceID * 20 + 10];
			_y = vert[instanceID * 20 + 11];
			vert[instanceID * 20 + 10] = _x * rotCos - _y * rotSin;
			vert[instanceID * 20 + 11] = _x * rotSin + _y * rotCos;

			_x = vert[instanceID * 20 + 15];
			_y = vert[instanceID * 20 + 16];
			vert[instanceID * 20 + 15] = _x * rotCos - _y * rotSin;
			vert[instanceID * 20 + 16] = _x * rotSin + _y * rotCos;
			b.vertices.unlock();
		}
		rotation = value;
		return value;
	}

	override inline function set_translationX(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = (value - translationX) / SUI.scene.backbuffer.width;

			var vert = b.vertices.lock();
			vert[instanceID * 20 + 0] += d;
			vert[instanceID * 20 + 5] += d;
			vert[instanceID * 20 + 10] += d;
			vert[instanceID * 20 + 15] += d;
			b.vertices.unlock();
		}
		translationX = value;
		return value;
	}

	override inline function set_translationY(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = (value - translationY) / SUI.scene.backbuffer.height;

			var vert = b.vertices.lock();
			vert[instanceID * 20 + 1] += d;
			vert[instanceID * 20 + 6] += d;
			vert[instanceID * 20 + 11] += d;
			vert[instanceID * 20 + 16] += d;
			b.vertices.unlock();
		}
		translationY = value;
		return value;
	}
}
