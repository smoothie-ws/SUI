package sui.core.graphics;

import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.Usage;
import kha.graphics4.VertexData;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.IndexBuffer;
import kha.graphics4.ConstantLocation;

class ElementPainter extends Shader2D {
	var numElements:Int = 0;

	var scale:Float32Array;
	var rotation:Float32Array;

	var resolutionCL:ConstantLocation;
	var scaleCL:ConstantLocation;
	var rotationCL:ConstantLocation;

	public function new() {}

	override function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_3X);
	}

	override function initVertices() {
		scale = new Float32Array(numElements * 4);
		rotation = new Float32Array(numElements * 3);

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

	override function getUniforms() {
		resolutionCL = pipeline.getConstantLocation("uResolution");
		scaleCL = pipeline.getConstantLocation("uScale");
		rotationCL = pipeline.getConstantLocation("uRotation");
	}

	override function setUniforms(target:Canvas) {
		target.g4.setInt2(resolutionCL, SUI.backbuffer.width, SUI.backbuffer.height);
		target.g4.setFloats(scaleCL, scale);
		target.g4.setFloats(rotationCL, rotation);
	}
}
