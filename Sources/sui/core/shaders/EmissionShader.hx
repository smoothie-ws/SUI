package sui.core.shaders;

import kha.Image;
import kha.FastFloat;
import kha.graphics4.Graphics;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;
// sui
import sui.Color;

class EmissionShader extends Shader2D {
	public var size:FastFloat;
	public var quality:Int;
	public var outer:Bool;
	public var color:Color;
	public var offsetX:FastFloat;
	public var offsetY:FastFloat;
	public var resolutionX:FastFloat;
	public var resolutionY:FastFloat;
	public var texture:Image;

	var sizeID:ConstantLocation;
	var offsetID:ConstantLocation;
	var colorID:ConstantLocation;
	var outerID:ConstantLocation;
	var qualityID:ConstantLocation;
	var resolutionID:ConstantLocation;
	var textureID:TextureUnit;

	public function new() {}

	override function getUniforms() {
		sizeID = pipeline.getConstantLocation("size");
		offsetID = pipeline.getConstantLocation("offset");
		colorID = pipeline.getConstantLocation("color");
		outerID = pipeline.getConstantLocation("outer");
		qualityID = pipeline.getConstantLocation("quality");
		resolutionID = pipeline.getConstantLocation("resolution");
		textureID = pipeline.getTextureUnit("tex");
	}

	override function setUniforms(graphics:Graphics) {
		graphics.setFloat(sizeID, size);
		graphics.setFloat2(offsetID, offsetX, offsetY);
		graphics.setFloat4(colorID, color.R / 255, color.G / 255, color.B / 255, color.A / 255);
		graphics.setBool(outerID, outer);
		graphics.setInt(qualityID, quality);
		graphics.setFloat2(resolutionID, resolutionX, resolutionY);
		graphics.setTexture(textureID, texture);
	}
}
