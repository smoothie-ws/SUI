package sui.core.graphics.shaders;

import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.TextureUnit;

class ImageDrawer extends Shader2D {
	var imageTU:TextureUnit;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_3X);
		structure.add("vertUV", VertexData.Float32_2X);
	}

	override inline function getUniforms() {
		imageTU = pipeline.getTextureUnit("tex");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(imageTU, uniforms[0]);
	}
}
