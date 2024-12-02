package sui.core.graphics.shaders;

import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class ImageDrawer extends Shader2D {
	var imageCL:ConstantLocation;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_3X);
		structure.add("vertUV", VertexData.Float32_2X);
	}

	override inline function getUniforms() {
		imageCL = pipeline.getConstantLocation("tex");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setFloats(imageCL, uniforms[0]);
	}
}
