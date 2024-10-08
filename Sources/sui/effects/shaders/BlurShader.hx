package sui.effects.shaders;

import kha.math.FastVector2;
import kha.FastFloat;
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;

class BlurShader extends Shader {
	public var sizeID:ConstantLocation;
	public var qualityID:ConstantLocation;
	public var resolutionID:ConstantLocation;

	public function new() {}

	override function getUniforms() {
		sizeID = pipeline.getConstantLocation("size");
		qualityID = pipeline.getConstantLocation("quality");
		resolutionID = pipeline.getConstantLocation("resolution");
	}

	override function setUniforms(g4:Graphics, args:Dynamic) {
		g4.setFloat(sizeID, args[0]);
		g4.setInt(qualityID, args[1]);
		g4.setVector2(resolutionID, new FastVector2(512, 512));
	}
}
