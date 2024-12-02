package sui.core.graphics.shaders;

import kha.Color;
import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class ColorDrawer extends Shader2D {
	var colorCL:ConstantLocation;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_3X);
	}

	override inline function getUniforms() {
		colorCL = pipeline.getConstantLocation("col");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		var color:Color = cast uniforms[0];
		target.g4.setFloat4(colorCL, color.R, color.G, color.B, color.A);
	}
}
