package sui.core.shaders;

import kha.Canvas;
import kha.Shaders;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.ConstantLocation;
// sui
import sui.Color;

class EmissionShader extends Shader2D {
	public var size:FastFloat;
	public var quality:FastFloat;
	public var color:Color;
	public var offsetX:FastFloat;
	public var offsetY:FastFloat;
	public var resolutionX:FastFloat;
	public var resolutionY:FastFloat;
	public var texture:FastFloat;

	var sizeID:ConstantLocation;
	var offsetID:ConstantLocation;
	var colorID:ConstantLocation;
	var outerID:ConstantLocation;
	var qualityID:ConstantLocation;
	var resolutionID:ConstantLocation;
	var textureID:TextureUnit;

	public function new() {
		super();
	}

	override function getUniforms() {
		sizeID = pipeline.getConstantLocation("size");
		offsetID = pipeline.getConstantLocation("offset");
		colorID = pipeline.getConstantLocation("color");
		outerID = pipeline.getConstantLocation("outer");
		qualityID = pipeline.getConstantLocation("quality");
		resolutionID = pipeline.getConstantLocation("resolution");
		textureID = pipeline.getTextureUnit("tex");
	}

	override function setUniforms(target:Canvas) {
		target.g4.setFloat(sizeID, size);
		target.g4.setFloat2(offsetID, offsetX, offsetY);
		target.g4.setFloat4(colorID, color.R / 255, color.G / 255, color.B / 255, color.A / 255);
		target.g4.setBool(outerID, outer);
		target.g4.setInt(qualityID, quality);
		target.g4.setFloat2(resolutionID, resolutionX, resolutionY);
		target.g4.setTexture(textureID, texture);
	}
}
