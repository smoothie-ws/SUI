package sui.elements.batches;

import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
// sui
import sui.core.graphics.SUIShaders;
import sui.elements.shapes.Rectangle;

class RectBatch extends ElementBatch {
	public var rectBounds:Float32Array;
	public var rectAttrib:Float32Array;
	public var rectColors:Float32Array;

	override inline function add(element:Element) {
		var rect:Rectangle = cast element;

		if (SUI.initialized)
			pushRect(rect);
	}

	override inline function construct() {
		var n = children.length;

		rectBounds = new Float32Array(n * 4);
		rectAttrib = new Float32Array(n * 2);
		rectColors = new Float32Array(n * 4);
		indices = new IndexBuffer(n * 6, StaticUsage);
		vertices = new VertexBuffer(n * 4, SUIShaders.rectShader.structure, StaticUsage);

		var ind = indices.lock();
		var vert = vertices.lock();

		for (i in 0...n) {
			var rect:Rectangle = cast children[i];

			rectBounds[i * 4 + 0] = rect.left.position;
			rectBounds[i * 4 + 1] = rect.top.position;
			rectBounds[i * 4 + 2] = rect.right.position;
			rectBounds[i * 4 + 3] = rect.bottom.position;
			rectAttrib[i * 2 + 0] = rect.radius;
			rectAttrib[i * 2 + 1] = rect.softness;
			rectColors[i * 4 + 0] = rect.color.R;
			rectColors[i * 4 + 1] = rect.color.G;
			rectColors[i * 4 + 2] = rect.color.B;
			rectColors[i * 4 + 3] = rect.color.A * rect.finalOpacity;

			ind[i * 6 + 0] = i * 4 + 0;
			ind[i * 6 + 1] = i * 4 + 1;
			ind[i * 6 + 2] = i * 4 + 2;
			ind[i * 6 + 3] = i * 4 + 2;
			ind[i * 6 + 4] = i * 4 + 3;
			ind[i * 6 + 5] = i * 4 + 0;

			var rotRad = Math.PI * rect.rotation / 180;
			var rotCos = Math.cos(rotRad);
			var rotSin = Math.sin(rotRad);
			var o = rect.mapToGlobal({x: rect.originX / SUI.scene.resolution, y: rect.originY / SUI.scene.resolution});
			var rox = o.x * 2 - 1;
			var roy = o.y * 2;
			var rtx = rect.translationX / SUI.scene.resolution;
			var rty = rect.translationY / SUI.scene.resolution;
			var ox = 1 - rox;
			var oy = 1 - roy;
			var ox_m = ox - 2;
			var oy_m = oy - 2;
			var otx = rox + rtx;
			var oty = roy + rty;
			ox *= rect.scaleX;
			ox_m *= rect.scaleX;
			oy *= rect.scaleY;
			oy_m *= rect.scaleY;

			vert[i * 20 + 0] = ox_m * rotCos - oy_m * rotSin + otx;
			vert[i * 20 + 1] = ox_m * rotSin + oy_m * rotCos + oty;
			vert[i * 20 + 2] = i;
			vert[i * 20 + 3] = 0;
			vert[i * 20 + 4] = 0;

			vert[i * 20 + 5] = ox_m * rotCos - oy * rotSin + otx;
			vert[i * 20 + 6] = ox_m * rotSin + oy * rotCos + oty;
			vert[i * 20 + 7] = i;
			vert[i * 20 + 8] = 0;
			vert[i * 20 + 9] = 1;

			vert[i * 20 + 10] = ox * rotCos - oy * rotSin + otx;
			vert[i * 20 + 11] = ox * rotSin + oy * rotCos + oty;
			vert[i * 20 + 12] = i;
			vert[i * 20 + 13] = 1;
			vert[i * 20 + 14] = 1;

			vert[i * 20 + 15] = ox * rotCos - oy_m * rotSin + otx;
			vert[i * 20 + 16] = ox * rotSin + oy_m * rotCos + oty;
			vert[i * 20 + 17] = i;
			vert[i * 20 + 18] = 1;
			vert[i * 20 + 19] = 0;
		}

		indices.unlock();
		vertices.unlock();
	}

	inline function pushRect(rect:Rectangle) {
		var i = rect.instanceID;
		var n = children.length;

		// expand arrays
		var _rectBounds = rectBounds;
		var _rectAttrib = rectAttrib;
		var _rectColors = rectColors;
		var _vertices = vertices._data;
		var _indices = indices._data;

		rectBounds = new Float32Array(n * 4);
		rectAttrib = new Float32Array(n * 2);
		rectColors = new Float32Array(n * 4);
		indices = new IndexBuffer(n * 6, StaticUsage);
		vertices = new VertexBuffer(n * 4, SUIShaders.rectShader.structure, StaticUsage);

		var ind = indices.lock();
		var vert = vertices.lock();

		for (i in 0...n - 1) {
			rectBounds[i * 4 + 0] = _rectBounds[i * 4 + 0];
			rectBounds[i * 4 + 1] = _rectBounds[i * 4 + 1];
			rectBounds[i * 4 + 2] = _rectBounds[i * 4 + 2];
			rectBounds[i * 4 + 3] = _rectBounds[i * 4 + 3];
			rectAttrib[i * 2 + 0] = _rectAttrib[i * 2 + 0];
			rectAttrib[i * 2 + 1] = _rectAttrib[i * 2 + 1];
			rectColors[i * 4 + 0] = _rectColors[i * 4 + 0];
			rectColors[i * 4 + 1] = _rectColors[i * 4 + 1];
			rectColors[i * 4 + 2] = _rectColors[i * 4 + 2];
			rectColors[i * 4 + 3] = _rectColors[i * 4 + 3];
			ind[i * 6 + 0] = _indices.getUint32((i * 4 + 0) * 4);
			vert[i * 4 + 0] = _vertices.getFloat32((i * 4 + 0) * 4);
		}

		// copy rect
		rectBounds[i * 4 + 0] = rect.left.position;
		rectBounds[i * 4 + 1] = rect.top.position;
		rectBounds[i * 4 + 2] = rect.right.position;
		rectBounds[i * 4 + 3] = rect.bottom.position;
		rectAttrib[i * 2 + 0] = rect.radius;
		rectAttrib[i * 2 + 1] = rect.softness;
		rectColors[i * 4 + 0] = rect.color.R;
		rectColors[i * 4 + 1] = rect.color.G;
		rectColors[i * 4 + 2] = rect.color.B;
		rectColors[i * 4 + 3] = rect.color.A * rect.finalOpacity;

		ind[i * 6 + 0] = i * 4 + 0;
		ind[i * 6 + 1] = i * 4 + 1;
		ind[i * 6 + 2] = i * 4 + 2;
		ind[i * 6 + 3] = i * 4 + 2;
		ind[i * 6 + 4] = i * 4 + 3;
		ind[i * 6 + 5] = i * 4 + 0;

		vert[i * 20 + 0] = -1;
		vert[i * 20 + 1] = -1;
		vert[i * 20 + 2] = i;
		vert[i * 20 + 3] = 0;
		vert[i * 20 + 4] = 0;

		vert[i * 20 + 5] = -1;
		vert[i * 20 + 6] = 1;
		vert[i * 20 + 7] = i;
		vert[i * 20 + 8] = 0;
		vert[i * 20 + 9] = 1;

		vert[i * 20 + 10] = 1;
		vert[i * 20 + 11] = 1;
		vert[i * 20 + 12] = i;
		vert[i * 20 + 13] = 1;
		vert[i * 20 + 14] = 1;

		vert[i * 20 + 15] = 1;
		vert[i * 20 + 16] = -1;
		vert[i * 20 + 17] = i;
		vert[i * 20 + 18] = 1;
		vert[i * 20 + 19] = 0;

		indices.unlock();
		vertices.unlock();
	}

	override public inline function draw(target:Canvas) {
		SUIShaders.rectShader.draw(target, vertices, indices, [rectBounds, rectAttrib, rectColors]);
	}
}
