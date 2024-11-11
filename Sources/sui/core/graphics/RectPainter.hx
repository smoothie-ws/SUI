package sui.core.graphics;

import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.ConstantLocation;
// sui
import sui.elements.shapes.Rectangle;

using sui.core.utils.Float32ArrayExtension;

class RectPainter extends ElementPainter {
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

	var rectRadiusCL:ConstantLocation;
	var rectBoundsCL:ConstantLocation;
	var rectColorCL:ConstantLocation;
	var rectSoftnessCL:ConstantLocation;
	var bordColorCL:ConstantLocation;
	var bordSoftnessCL:ConstantLocation;
	var bordThicknessCL:ConstantLocation;
	var emisColorCL:ConstantLocation;
	var emisOffsetCL:ConstantLocation;
	var emisSoftnessCL:ConstantLocation;
	var emisSizeCL:ConstantLocation;
	var opacityCL:ConstantLocation;

	public final inline function setRects(rects:Array<Rectangle>) {
		numElements = rects.length;
		initVertices();

		for (i in 0...rects.length) {
			var rect = rects[i];

			opacity[i] = rect.finalOpacity;
			rotation.setArray([rect.centerX, rect.centerY, rect.finalRotation], i * 3);
			scale.setArray([rect.centerX, rect.centerY, rect.finalScaleX, rect.finalScaleY], i * 4);

			var maxR = Math.min(rect.width, rect.height) / 2;
			rectSoftness[i] = rect.softness;
			rectColor.setColor(rect.color, i * 4);
			trace(rect.centerX, rect.centerY, rect.finalW, rect.finalH);
			rectBounds.setArray([rect.centerX, rect.centerY, rect.finalW, rect.finalH], i * 4);
			rectRadius.setArray([
				Math.min(Math.isNaN(rect.topLeftRadius) ? rect.radius : rect.topLeftRadius, maxR),
				Math.min(Math.isNaN(rect.topLeftRadius) ? rect.radius : rect.topLeftRadius, maxR),
				Math.min(Math.isNaN(rect.topLeftRadius) ? rect.radius : rect.topLeftRadius, maxR),
				Math.min(Math.isNaN(rect.topLeftRadius) ? rect.radius : rect.topLeftRadius, maxR)
			], i * 4);

			bordSoftness[i] = rect.border.softness;
			bordThickness[i] = rect.border.thickness / 2;
			bordColor.setColor(rect.border.color, i * 4);

			emisSize[i] = Math.max(0, rect.emission.size);
			emisColor.setColor(rect.emission.color, i * 4);
			emisSoftness[i] = Math.max(0, rect.emission.softness);
			emisOffset.setArray([rect.emission.offsetX, rect.emission.offsetY], i * 2);
		}
	}

	final override inline function initVertices() {
		scale = new Float32Array(numElements * 4);
		rotation = new Float32Array(numElements * 3);
		rectRadius = new Float32Array(numElements * 4);
		rectBounds = new Float32Array(numElements * 4);
		rectColor = new Float32Array(numElements * 4);
		rectSoftness = new Float32Array(numElements * 1);
		bordColor = new Float32Array(numElements * 4);
		bordSoftness = new Float32Array(numElements * 1);
		bordThickness = new Float32Array(numElements * 1);
		emisColor = new Float32Array(numElements * 4);
		emisOffset = new Float32Array(numElements * 2);
		emisSoftness = new Float32Array(numElements * 1);
		emisSize = new Float32Array(numElements * 1);
		opacity = new Float32Array(numElements * 1);

		vertices = new VertexBuffer(numElements * 4, structure, Usage.StaticUsage);
		var v = vertices.lock();
		for (i in 0...numElements) {
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

		indices = new IndexBuffer(numElements * 6, Usage.StaticUsage);
		var ind = indices.lock();
		for (i in 0...numElements) {
			ind[i * 6 + 0] = i * 4 + 0;
			ind[i * 6 + 1] = i * 4 + 1;
			ind[i * 6 + 2] = i * 4 + 2;
			ind[i * 6 + 3] = i * 4 + 2;
			ind[i * 6 + 4] = i * 4 + 3;
			ind[i * 6 + 5] = i * 4 + 0;
		}
		indices.unlock();
	}

	final override inline function getUniforms() {
		scaleCL = pipeline.getConstantLocation("uScale");
		rotationCL = pipeline.getConstantLocation("uRotation");
		resolutionCL = pipeline.getConstantLocation("uResolution");
		rectRadiusCL = pipeline.getConstantLocation("uRectRadius");
		rectBoundsCL = pipeline.getConstantLocation("uRectBounds");
		rectColorCL = pipeline.getConstantLocation("uRectColor");
		rectSoftnessCL = pipeline.getConstantLocation("uRectSoftness");
		bordColorCL = pipeline.getConstantLocation("uBordColor");
		bordSoftnessCL = pipeline.getConstantLocation("uBordSoftness");
		bordThicknessCL = pipeline.getConstantLocation("uBordThickness");
		emisColorCL = pipeline.getConstantLocation("uEmisColor");
		emisOffsetCL = pipeline.getConstantLocation("uEmisOffset");
		emisSoftnessCL = pipeline.getConstantLocation("uEmisSoftness");
		emisSizeCL = pipeline.getConstantLocation("uEmisSize");
		opacityCL = pipeline.getConstantLocation("uOpacity");
	}

	final override inline function setUniforms(target:Canvas) {
		target.g4.setInt2(resolutionCL, target.width, target.height);
		target.g4.setFloats(scaleCL, scale);
		target.g4.setFloats(rotationCL, rotation);
		target.g4.setFloats(rectRadiusCL, rectRadius);
		target.g4.setFloats(rectBoundsCL, rectBounds);
		target.g4.setFloats(rectColorCL, rectColor);
		target.g4.setFloats(rectSoftnessCL, rectSoftness);
		target.g4.setFloats(bordColorCL, bordColor);
		target.g4.setFloats(bordSoftnessCL, bordSoftness);
		target.g4.setFloats(bordThicknessCL, bordThickness);
		target.g4.setFloats(emisColorCL, emisColor);
		target.g4.setFloats(emisOffsetCL, emisOffset);
		target.g4.setFloats(emisSoftnessCL, emisSoftness);
		target.g4.setFloats(emisSizeCL, emisSize);
		target.g4.setFloats(opacityCL, opacity);
	}
}
