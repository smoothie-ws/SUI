package sui.core.graphics;

import kha.Color;
import kha.math.FastVector4;
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;
// sui
import sui.core.shaders.Shader2D;

class CirclePainter extends Shader2D {
	public var dims = new FastVector4();
	public var color:Color;

	var colID:ConstantLocation;
	var resID:ConstantLocation;
	var dimsID:ConstantLocation;

	public function new() {}

	override inline function getUniforms() {
		colID = pipeline.getConstantLocation("col");
		resID = pipeline.getConstantLocation("res");
		dimsID = pipeline.getConstantLocation("dims");
	}

	override function setUniforms(graphics:Graphics) {
		graphics.setFloat2(resID, SUI.options.width, SUI.options.height);
		graphics.setFloat4(colID, color.R, color.G, color.B, color.A);
		graphics.setVector4(dimsID, dims);
	}
}
