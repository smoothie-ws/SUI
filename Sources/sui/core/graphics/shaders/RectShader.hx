package sui.core.graphics.shaders;

import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class RectShader extends Shader2D {
	var resolutionCL:ConstantLocation;
	var rectBoundsCL:ConstantLocation;
	var rectAttribCL:ConstantLocation;
	var gradColorsCL:ConstantLocation;
	var gradAttribCL:ConstantLocation;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_3X);
	}

	override inline function getUniforms() {
		resolutionCL = pipeline.getConstantLocation("uResolution");
		rectBoundsCL = pipeline.getConstantLocation("uRectBounds");
		rectAttribCL = pipeline.getConstantLocation("uRectAttrib");
		gradColorsCL = pipeline.getConstantLocation("uGradColors");
		gradAttribCL = pipeline.getConstantLocation("uGradAttrib");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setFloat4(resolutionCL, target.width, target.height, SUI.scene.width, SUI.scene.height);
		target.g4.setFloats(rectBoundsCL, uniforms[0]);
		target.g4.setFloats(rectAttribCL, uniforms[1]);
		target.g4.setFloats(gradColorsCL, uniforms[2]);
		target.g4.setFloats(gradAttribCL, uniforms[3]);
	}
}
