package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.elements.batches.RectBatch;

class Rectangle extends DrawableElement {
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

	override inline function set_color(value:Color) {
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
			var o = mapToGlobal(origin);
			var ox = o.x / SUI.scene.resolution * 2 - 1;

			var ioffset = instanceID * 20;

			var vert = b.vertices.lock();
			for (i in 0...4)
				vert[ioffset + i * 5] = (vert[ioffset + i * 5] - ox) * d + ox;
			b.vertices.unlock();
		}
		scaleX = value;
		return value;
	}

	override inline function set_scaleY(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = value / scaleY;
			var o = mapToGlobal(origin);
			var oy = 1 - o.y / SUI.scene.resolution * 2;

			var ioffset = instanceID * 20;

			var vert = b.vertices.lock();
			for (i in 0...4)
				vert[ioffset + i * 5 + 1] = (vert[ioffset + i * 5 + 1] - oy) * d + oy;
			b.vertices.unlock();
		}
		scaleY = value;
		return value;
	}

	override inline function set_rotation(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = value - rotation;
			var o = mapToGlobal(origin);
			var ox = o.x / SUI.scene.resolution * 2 - 1;
			var oy = o.x / SUI.scene.resolution * 2 - 1;
			var rotRad = Math.PI * d / 180;
			var rotCos = Math.cos(rotRad);
			var rotSin = Math.sin(rotRad);

			var ioffset = instanceID * 20;

			var vert = b.vertices.lock();
			for (i in 0...4) {
				var j = i * 5;
				var _x = vert[ioffset + j] - ox;
				var _y = vert[ioffset + j + 1] - oy;
				vert[ioffset + j] = _x * rotCos - _y * rotSin + ox;
				vert[ioffset + j + 1] = _x * rotSin + _y * rotCos + oy;
			}
			b.vertices.unlock();
		}
		rotation = value;
		return value;
	}

	override inline function set_translationX(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = (value - translationX) / SUI.scene.resolution;

			var ioffset = instanceID * 20;

			var vert = b.vertices.lock();
			for (i in 0...4)
				vert[ioffset + i * 5] += d;
			b.vertices.unlock();
		}
		translationX = value;
		return value;
	}

	override inline function set_translationY(value:FastFloat) {
		if (batch != null) {
			var b:RectBatch = cast batch;
			var d = (value - translationY) / SUI.scene.resolution;

			var ioffset = instanceID * 20;

			var vert = b.vertices.lock();
			for (i in 0...4)
				vert[ioffset + i * 5 + 1] += d;
			b.vertices.unlock();
		}
		translationY = value;
		return value;
	}
}
