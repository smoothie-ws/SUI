package sui.elements.batches;

import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.SUIShaders;
import sui.elements.shapes.Rectangle;

class RectBatch extends ElementBatch {
	public var rectBounds:Float32Array;
	public var rectAttrib:Float32Array;
	public var rectColors:Float32Array;

	override inline function add(element:Element) {
		if (SUI.initialized)
			construct();
	}

	inline function copyRect(rect:Rectangle) {
		var i = rect.instanceID;

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

		var ind = indices.lock();
		ind[i * 6 + 0] = i * 4 + 0;
		ind[i * 6 + 1] = i * 4 + 1;
		ind[i * 6 + 2] = i * 4 + 2;
		ind[i * 6 + 3] = i * 4 + 2;
		ind[i * 6 + 4] = i * 4 + 3;
		ind[i * 6 + 5] = i * 4 + 0;
		indices.unlock();

		var rotRad = Math.PI * rect.rotation / 180;
		var rotCos = Math.cos(rotRad);
		var rotSin = Math.sin(rotRad);
		var o = rect.mapToGlobal(rect.origin);
		var rox = o.x / SUI.scene.resolution * 2 - 1;
		var roy = o.x / SUI.scene.resolution * 2 - 1;
		var ox = 1 - rox;
		var oy = 1 - roy;
		var ox_m = ox - 2;
		var oy_m = oy - 2;
		var otx = rox + rect.translationX / SUI.scene.resolution;
		var oty = roy + rect.translationY / SUI.scene.resolution;
		ox *= rect.scaleX;
		ox_m *= rect.scaleX;
		oy *= rect.scaleY;
		oy_m *= rect.scaleY;

		var vert = vertices.lock();
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
		vertices.unlock();
	}

	override inline function construct() {
		var n = children.length;

		rectBounds = new Float32Array(n * 4);
		rectAttrib = new Float32Array(n * 2);
		rectColors = new Float32Array(n * 4);
		indices = new IndexBuffer(n * 6, StaticUsage);
		vertices = new VertexBuffer(n * 4, SUIShaders.rectShader.structure, StaticUsage);

		for (c in children)
			copyRect(cast(c, Rectangle));
	}

	override public inline function draw(target:Canvas) {
		SUIShaders.rectShader.draw(target, vertices, indices, [rectBounds, rectAttrib, rectColors]);
	}
}
