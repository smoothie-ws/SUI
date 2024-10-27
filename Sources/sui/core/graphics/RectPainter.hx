package sui.core.graphics;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector4;
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;
// sui
import sui.core.shaders.Shader2D;

class RectPainter extends Shader2D {
	public var dims = new FastVector4();
	public var color:Color;
	public var radius:FastFloat;

	var resID:ConstantLocation;
	var dimsID:ConstantLocation;
	var colID:ConstantLocation;
	var radiusID:ConstantLocation;

	public function new() {}

	override inline function getUniforms() {
		dimsID = pipeline.getConstantLocation("dims");
		colID = pipeline.getConstantLocation("col");
		radiusID = pipeline.getConstantLocation("radius");
		resID = pipeline.getConstantLocation("res");
	}

	override function setUniforms(graphics:Graphics) {
		graphics.setFloat(radiusID, radius);
		graphics.setFloat2(resID, SUI.options.width, SUI.options.height);
		graphics.setFloat4(colID, color.R, color.G, color.B, color.A);
		graphics.setVector4(dimsID, dims);
	}
}
