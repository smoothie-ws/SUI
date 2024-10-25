package sui.core.shaders;

import kha.Image;
import kha.FastFloat;
import kha.graphics4.Graphics;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

class BlurShader extends Shader2D {
	public var size:FastFloat;
	public var quality:Int;
	public var resolutionX:FastFloat;
	public var resolutionY:FastFloat;
	public var texture:Image;

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

	override function setUniforms(graphics:Graphics) {
		graphics.setFloat(sizeID, size);
		graphics.setInt(qualityID, quality);
		graphics.setFloat2(resolutionID, resolutionX, resolutionY);
		graphics.setTexture(textureID, texture);
	}
}
