package sui.core.shaders;

import kha.Image;
import kha.FastFloat;
import kha.graphics4.Graphics;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

class BlurShader extends Shader2D {
	public var size:FastFloat;
	public var quality:Int;
	public var resX:FastFloat;
	public var resY:FastFloat;
	public var texture:Image;
	public var mask:Image;

	var sizeID:ConstantLocation;
	var qualityID:ConstantLocation;
	var resID:ConstantLocation;
	var textureID:TextureUnit;
	var maskID:TextureUnit;

	public function new() {}

	override inline function getUniforms() {
		sizeID = pipeline.getConstantLocation("size");
		qualityID = pipeline.getConstantLocation("quality");
		resID = pipeline.getConstantLocation("res");
		textureID = pipeline.getTextureUnit("tex");
		maskID = pipeline.getTextureUnit("mask");
	}

	override function setUniforms(graphics:Graphics) {
		graphics.setFloat(sizeID, size);
		graphics.setInt(qualityID, quality);
		graphics.setFloat2(resID, resX, resY);
		graphics.setTexture(textureID, texture);
		graphics.setTexture(maskID, mask);
	}
}
