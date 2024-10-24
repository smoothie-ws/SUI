package sui.core.shaders;

import kha.math.FastVector2;
import kha.FastFloat;
import kha.Canvas;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

class BlurShader extends Shader2D {
	public var size:FastFloat;
	public var quality:FastFloat;
	public var resolutionX:FastFloat;
	public var resolutionY:FastFloat;
	public var texture:FastFloat;

	var sizeID:ConstantLocation;
	var qualityID:ConstantLocation;
	var resolutionID:ConstantLocation;
	var textureID:TextureUnit;

	public function new() {
		super();
	}

	override inline function getUniforms() {
		sizeID = pipeline.getConstantLocation("size");
		qualityID = pipeline.getConstantLocation("quality");
		resolutionID = pipeline.getConstantLocation("resolution");
		textureID = pipeline.getTextureUnit("tex");
	}

	override inline function setUniforms(target:Canvas) {
		target.g4.setFloat(sizeID, size);
		target.g4.setInt(qualityID, quality);
		target.g4.setFloat2(resolutionID, resolutionX, resolutionY);
		target.g4.setTexture(textureID, texture);
	}
}
