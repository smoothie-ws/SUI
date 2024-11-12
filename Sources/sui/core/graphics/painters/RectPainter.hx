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
	var scale:Float32Array;
	var rotation:Float32Array;
	var rectRadius:Float32Array;
	var rectBounds:Float32Array;
	var rectColor:Float32Array;
	var rectSoftness:Float32Array;
	var bordColor:Float32Array;
	var bordSoftness:Float32Array;
	var bordThickness:Float32Array;
	var emisColor:Float32Array;
	var emisOffset:Float32Array;
	var emisSoftness:Float32Array;
	var emisSize:Float32Array;
	var opacity:Float32Array;

	public final inline function setRects() {
		scale = new Float32Array(elements.length * 4);
		rotation = new Float32Array(elements.length * 3);
		rectRadius = new Float32Array(elements.length * 4);
		rectBounds = new Float32Array(elements.length * 4);
		rectColor = new Float32Array(elements.length * 4);
		rectSoftness = new Float32Array(elements.length * 1);
		bordColor = new Float32Array(elements.length * 4);
		bordSoftness = new Float32Array(elements.length * 1);
		bordThickness = new Float32Array(elements.length * 1);
		emisColor = new Float32Array(elements.length * 4);
		emisOffset = new Float32Array(elements.length * 2);
		emisSoftness = new Float32Array(elements.length * 1);
		emisSize = new Float32Array(elements.length * 1);
		opacity = new Float32Array(elements.length * 1);

		initVertices();

		for (i in 0...elements.length) {
			var rect:Rectangle = cast elements[i];

			var sOX = rect.transform.scale.origin.x;
			var sOY = rect.transform.scale.origin.y;
			var rOX = rect.transform.rotation.origin.x;
			var rOY = rect.transform.rotation.origin.y;
			var rMax = Math.min(rect.finalW, rect.finalH) / 2;

			opacity[i] = rect.finalOpacity;
			rotation[i * 3 + 0] = ((Math.isNaN(rOX) ? rect.centerX : rOX) / SUI.backbuffer.width) * 2 - 1;
			rotation[i * 3 + 1] = ((Math.isNaN(rOY) ? rect.centerY : rOY) / SUI.backbuffer.height) * 2 - 1;
			rotation[i * 3 + 2] = rect.finalRotation * Math.PI / 180;
			scale[i * 4 + 0] = ((Math.isNaN(sOX) ? rect.centerX : sOX) / SUI.backbuffer.width) * 2 - 1;
			scale[i * 4 + 1] = ((Math.isNaN(sOY) ? rect.centerY : sOY) / SUI.backbuffer.height) * 2 - 1;
			scale[i * 4 + 2] = rect.finalScaleX;
			scale[i * 4 + 3] = rect.finalScaleY;
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

			bordSoftness[i] = rect.border.softness;
			bordThickness[i] = rect.border.thickness / 2;
			bordColor[i * 4 + 0] = rect.border.color.R;
			bordColor[i * 4 + 1] = rect.border.color.G;
			bordColor[i * 4 + 2] = rect.border.color.B;
			bordColor[i * 4 + 3] = rect.border.color.A;

			emisSize[i] = Math.max(0, rect.emission.size);
			emisColor[i * 4 + 0] = rect.emission.color.R;
			emisColor[i * 4 + 1] = rect.emission.color.G;
			emisColor[i * 4 + 2] = rect.emission.color.B;
			emisColor[i * 4 + 3] = rect.emission.color.A;
			emisSoftness[i] = Math.max(0, rect.emission.softness);
			emisOffset[i * 2 + 0] = rect.emission.offsetX;
			emisOffset[i * 2 + 1] = rect.emission.offsetY;
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
			scale,
			rotation,
			rectRadius,
			rectBounds,
			rectColor,
			rectSoftness,
			bordColor,
			bordSoftness,
			bordThickness,
			emisColor,
			emisOffset,
			emisSoftness,
			emisSize,
			opacity,
		]);
	}
}
