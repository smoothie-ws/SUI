package sui.core.graphics;

import kha.FastFloat;
import kha.math.FastVector4;
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;
// sui
import sui.Color;
import sui.core.shaders.Shader2D;

class EllipsePainter extends Shader2D {
	public var dims = new FastVector4();
	public var color:Color;
	public var smoothness:FastFloat;

	var dimsID:ConstantLocation;
	var colorID:ConstantLocation;
	var resolutionID:ConstantLocation;
	var smoothnessID:ConstantLocation;

	public function new() {}

	override inline function getUniforms() {
		dimsID = pipeline.getConstantLocation("dims");
		colorID = pipeline.getConstantLocation("color");
		resolutionID = pipeline.getConstantLocation("resolution");
		smoothnessID = pipeline.getConstantLocation("smoothness");
	}

	override function setUniforms(graphics:Graphics) {
		graphics.setFloat(smoothnessID, smoothness);
		graphics.setFloat2(resolutionID, SUI.options.width, SUI.options.height);
		graphics.setFloat4(colorID, color.R / 255, color.G / 255, color.B / 255, color.A / 255);
		graphics.setVector4(dimsID, dims);
	}
}
