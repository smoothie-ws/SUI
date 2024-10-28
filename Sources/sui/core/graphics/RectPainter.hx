package sui.core.graphics;

import kha.Color;
import kha.math.FastVector4;
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;
// sui
import sui.core.shaders.Shader2D;

class RectPainter extends Shader2D {
	public var color:Color;
	public var dims:FastVector4 = new FastVector4();
	public var radiuses:FastVector4 = new FastVector4();

	var resID:ConstantLocation;
	var dimsID:ConstantLocation;
	var colID:ConstantLocation;
	var radiusesID:ConstantLocation;

	public function new() {}

	override inline function getUniforms() {
		colID = pipeline.getConstantLocation("col");
		resID = pipeline.getConstantLocation("res");
		dimsID = pipeline.getConstantLocation("dims");
		radiusesID = pipeline.getConstantLocation("radiuses");
	}

	override function setUniforms(graphics:Graphics) {
		graphics.setVector4(dimsID, dims);
		graphics.setVector4(radiusesID, radiuses);
		graphics.setFloat4(colID, color.R, color.G, color.B, color.A);
		graphics.setFloat2(resID, SUI.options.width, SUI.options.height);
	}
}
