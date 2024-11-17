package sui.core.graphics.painters;

import kha.math.FastVector4;
import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
// sui
import sui.elements.shapes.Rectangle;
import sui.core.graphics.painters.shaders.PainterShaders;

class RectPainter extends ElementPainter {
	var rectBounds:Float32Array;
	var rectAttrib:Float32Array;
	var gradColors:Float32Array;
	var gradAttrib:Float32Array;

	public final inline function setRects() {
		rectBounds = new Float32Array(elements.length * 4);
		rectAttrib = new Float32Array(elements.length * 2);
		gradColors = new Float32Array(elements.length * 4 * 2);
		gradAttrib = new Float32Array(elements.length * 4);

		initVertices();

		for (i in 0...elements.length) {
			var rect:Rectangle = cast elements[i];

			var bounds = new FastVector4(rect.left.position, rect.top.position, rect.right.position, rect.bottom.position);
			bounds.x = (bounds.x + bounds.z) / 2;
			bounds.y = (bounds.y + bounds.w) / 2;

			rectBounds[i * 4 + 0] = bounds.x;
			rectBounds[i * 4 + 1] = bounds.y;
			rectBounds[i * 4 + 2] = bounds.z;
			rectBounds[i * 4 + 3] = bounds.w;
			rectAttrib[i * 2 + 0] = Math.min(rect.radius, Math.min(bounds.z, bounds.w) / 2);
			rectAttrib[i * 2 + 1] = rect.softness;

			if (rect.gradient != null) {
				gradColors[i * 4 + 0] = rect.gradient.end.R;
				gradColors[i * 4 + 1] = rect.gradient.end.G;
				gradColors[i * 4 + 2] = rect.gradient.end.B;
				gradColors[i * 4 + 3] = rect.gradient.end.A * rect.finalOpacity;
				gradColors[i * 4 + 4] = rect.gradient.start.R;
				gradColors[i * 4 + 5] = rect.gradient.start.G;
				gradColors[i * 4 + 6] = rect.gradient.start.B;
				gradColors[i * 4 + 7] = rect.gradient.start.A * rect.finalOpacity;
				gradAttrib[i * 4 + 0] = rect.gradient.alignByElement ? 1.0 : 2.0;
				gradAttrib[i * 4 + 1] = rect.gradient.angle;
				gradAttrib[i * 4 + 2] = rect.gradient.position;
				gradAttrib[i * 4 + 3] = rect.gradient.scale;
			} else {
				gradColors[i * 4 + 0] = rect.color.R;
				gradColors[i * 4 + 1] = rect.color.G;
				gradColors[i * 4 + 2] = rect.color.B;
				gradColors[i * 4 + 3] = rect.color.A * rect.finalOpacity;
				gradColors[i * 4 + 4] = rect.color.R;
				gradColors[i * 4 + 5] = rect.color.G;
				gradColors[i * 4 + 6] = rect.color.B;
				gradColors[i * 4 + 7] = rect.color.A * rect.finalOpacity;
			}
		}
	}

	final inline function initVertices() {
		vertices = new VertexBuffer(elements.length * 4, PainterShaders.rectPainterShader.structure, Usage.StaticUsage);
		var v = vertices.lock();
		for (i in 0...elements.length) {
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

		indices = new IndexBuffer(elements.length * 6, Usage.StaticUsage);
		var ind = indices.lock();
		for (i in 0...elements.length) {
			ind[i * 6 + 0] = i * 4 + 0;
			ind[i * 6 + 1] = i * 4 + 1;
			ind[i * 6 + 2] = i * 4 + 2;
			ind[i * 6 + 3] = i * 4 + 2;
			ind[i * 6 + 4] = i * 4 + 3;
			ind[i * 6 + 5] = i * 4 + 0;
		}
		indices.unlock();
	}

	public override function draw(target:Canvas) {
		setRects();
		PainterShaders.rectPainterShader.draw(target, vertices, indices, [rectBounds, rectAttrib, gradColors, gradAttrib]);
	}
}
