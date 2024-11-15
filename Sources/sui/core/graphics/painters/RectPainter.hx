package sui.core.graphics.painters;

import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
// sui
import sui.elements.shapes.Rectangle;
import sui.core.graphics.painters.shaders.PainterShaders;

class RectPainter extends ElementPainter {
	var transformOrigin:Float32Array;
	var scaleRotation:Float32Array;
	var rectRadius:Float32Array;
	var rectBounds:Float32Array;
	var rectColor:Float32Array;
	var rectSoftness:Float32Array;
	var opacity:Float32Array;
	var gradColors:Float32Array;
	var gradAttrib:Float32Array;

	public final inline function setRects() {
		transformOrigin = new Float32Array(elements.length * 2);
		scaleRotation = new Float32Array(elements.length * 3);
		rectRadius = new Float32Array(elements.length * 4);
		rectBounds = new Float32Array(elements.length * 4);
		rectColor = new Float32Array(elements.length * 4);
		rectSoftness = new Float32Array(elements.length * 1);
		opacity = new Float32Array(elements.length * 1);
		gradColors = new Float32Array(elements.length * 4 * 2);
		gradAttrib = new Float32Array(elements.length * 4);

		initVertices();

		for (i in 0...elements.length) {
			var rect:Rectangle = cast elements[i];
			var rMax = Math.min(rect.finalW, rect.finalH) / 2;

			opacity[i] = rect.finalOpacity;

			transformOrigin[i * 2 + 0] = ((rect.finalX + rect.origin.x) / SUI.backbuffer.width) * 2 - 1;
			transformOrigin[i * 2 + 1] = ((rect.finalY + rect.origin.y) / SUI.backbuffer.height) * 2 - 1;
			scaleRotation[i * 3 + 0] = rect.scale.x;
			scaleRotation[i * 3 + 1] = rect.scale.y;
			scaleRotation[i * 3 + 2] = rect.rotation;
			
			rectSoftness[i] = rect.softness;
			rectColor[i * 4 + 0] = rect.color.R;
			rectColor[i * 4 + 1] = rect.color.G;
			rectColor[i * 4 + 2] = rect.color.B;
			rectColor[i * 4 + 3] = rect.color.A;
			rectBounds[i * 4 + 0] = rect.centerX;
			rectBounds[i * 4 + 1] = rect.centerY;
			rectBounds[i * 4 + 2] = rect.finalW;
			rectBounds[i * 4 + 3] = rect.finalH;

			rectRadius[i * 4 + 0] = Math.min(Math.isNaN(rect.topLeftRadius) ? rect.radius : rect.topLeftRadius, rMax);
			rectRadius[i * 4 + 1] = Math.min(Math.isNaN(rect.topRightRadius) ? rect.radius : rect.topLeftRadius, rMax);
			rectRadius[i * 4 + 2] = Math.min(Math.isNaN(rect.bottomRightRadius) ? rect.radius : rect.topLeftRadius, rMax);
			rectRadius[i * 4 + 3] = Math.min(Math.isNaN(rect.bottomLeftRadius) ? rect.radius : rect.topLeftRadius, rMax);

			if (rect.gradient != null) {
				gradColors[i * 4 + 0] = rect.gradient.end.R;
				gradColors[i * 4 + 1] = rect.gradient.end.G;
				gradColors[i * 4 + 2] = rect.gradient.end.B;
				gradColors[i * 4 + 3] = rect.gradient.end.A;
				gradColors[i * 4 + 4] = rect.gradient.start.R;
				gradColors[i * 4 + 5] = rect.gradient.start.G;
				gradColors[i * 4 + 6] = rect.gradient.start.B;
				gradColors[i * 4 + 7] = rect.gradient.start.A;
				gradAttrib[i * 4 + 0] = rect.gradient.alignByElement ? 1.0 : 2.0;
				gradAttrib[i * 4 + 1] = rect.gradient.angle;
				gradAttrib[i * 4 + 2] = rect.gradient.position;
				gradAttrib[i * 4 + 3] = rect.gradient.scale;
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
		PainterShaders.rectPainterShader.draw(target, vertices, indices, [
			transformOrigin,
			scaleRotation,
			rectRadius,
			rectBounds,
			rectColor,
			rectSoftness,
			opacity,
			gradColors,
			gradAttrib
		]);
	}
}
