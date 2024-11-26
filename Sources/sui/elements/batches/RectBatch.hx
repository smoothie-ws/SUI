package sui.elements.batches;

import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
// sui
import sui.core.graphics.SUIShaders;
import sui.elements.shapes.Rectangle;

class RectBatch extends ElementBatch {
	public var rectBounds:Float32Array;
	public var rectAttrib:Float32Array;
	public var rectColors:Float32Array;

	inline function pushRect(rect:Rectangle) {
		var i = rect.instanceID;
		var o = rect.finalOpacity;

		rectBounds[i * 4 + 0] = rect.left.position;
		rectBounds[i * 4 + 1] = rect.top.position;
		rectBounds[i * 4 + 2] = rect.right.position;
		rectBounds[i * 4 + 3] = rect.bottom.position;
		rectAttrib[i * 2 + 0] = rect.radius;
		rectAttrib[i * 2 + 1] = rect.softness;
		rectColors[i * 4 + 0] = rect.color.R;
		rectColors[i * 4 + 1] = rect.color.G;
		rectColors[i * 4 + 2] = rect.color.B;
		rectColors[i * 4 + 3] = rect.color.A * o;
	}

	override inline function addChild(element:Element) {
		var rect:Rectangle = cast element;
		rect.batch = this;
		rect.instanceID = children.push(element) - 1;

		var _rectBounds = rectBounds;
		var _rectAttrib = rectAttrib;
		var _rectColors = rectColors;
		rectBounds = new Float32Array(children.length * 4);
		rectAttrib = new Float32Array(children.length * 2);
		rectColors = new Float32Array(children.length * 4);

		for (i in 0...children.length - 1) {
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
		}

		pushRect(rect);
	}

	override public inline function draw(target:Canvas) {
		vertices = new VertexBuffer(children.length * 4, SUIShaders.rectShader.structure, Usage.StaticUsage);
		var v = vertices.lock();
		for (i in 0...children.length) {
			v[i * 12 + 0] = -1;
			v[i * 12 + 1] = -1;
			v[i * 12 + 2] = i;

			v[i * 12 + 3] = -1;
			v[i * 12 + 4] = 1;
			v[i * 12 + 5] = i;

			v[i * 12 + 6] = 1;
			v[i * 12 + 7] = 1;
			v[i * 12 + 8] = i;

			v[i * 12 + 9] = 1;
			v[i * 12 + 10] = -1;
			v[i * 12 + 11] = i;
		}
		vertices.unlock();

		indices = new IndexBuffer(children.length * 6, Usage.StaticUsage);
		var ind = indices.lock();
		for (i in 0...children.length) {
			ind[i * 6 + 0] = i * 4 + 0;
			ind[i * 6 + 1] = i * 4 + 1;
			ind[i * 6 + 2] = i * 4 + 2;
			ind[i * 6 + 3] = i * 4 + 2;
			ind[i * 6 + 4] = i * 4 + 3;
			ind[i * 6 + 5] = i * 4 + 0;
		}
		indices.unlock();

		SUIShaders.rectShader.draw(target, vertices, indices, [rectBounds, rectAttrib, rectColors]);
	}
}
