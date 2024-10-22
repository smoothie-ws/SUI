package sui.core.shaders;

import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;

class EmissionShader extends Shader {
	public var sizeID:ConstantLocation;
	public var offsetID:ConstantLocation;
	public var colorID:ConstantLocation;
	public var outerID:ConstantLocation;
	public var qualityID:ConstantLocation;
	public var resolutionID:ConstantLocation;

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
	}

	override function setUniforms(g4:Graphics, args:Dynamic) {
		// [size, offsetX, offsetY, color, outer, quality]

		g4.setFloat(sizeID, args[0]);
		g4.setFloat2(offsetID, args[1], args[2]);

		var col = args[3];
		g4.setFloat4(colorID, col.R / 255, col.G / 255, col.B / 255, col.A / 255);

		g4.setInt(qualityID, args[5]);
		g4.setFloat2(resolutionID, SUI.options.width, SUI.options.height);
	}
}
