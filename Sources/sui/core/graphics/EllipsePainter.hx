package sui.core.graphics;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector4;
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;
// sui
import sui.core.shaders.Shader2D;

class EllipsePainter extends Shader2D {
	public var dims = new FastVector4();
	public var color:Color;
	public var smoothness:FastFloat;

	var dimsID:ConstantLocation;
	var colorID:ConstantLocation;
	var resID:ConstantLocation;
	var smoothnessID:ConstantLocation;

	public function new() {}

	override inline function getUniforms() {
		dimsID = pipeline.getConstantLocation("dims");
		colorID = pipeline.getConstantLocation("color");
		resID = pipeline.getConstantLocation("res");
		smoothnessID = pipeline.getConstantLocation("smoothness");
	}

	override function setUniforms(graphics:Graphics) {
		graphics.setFloat(smoothnessID, smoothness);
		graphics.setFloat2(resID, SUI.options.width, SUI.options.height);
		graphics.setFloat4(colorID, color.R, color.G, color.B, color.A);
		graphics.setVector4(dimsID, dims);
	}
}
