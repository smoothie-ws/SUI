package sui.core.graphics.painters.shaders;

import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class RectPainterShader extends Shader2D {
	var resolutionCL:ConstantLocation;
	var transformOriginCL:ConstantLocation;
	var scaleRotationCL:ConstantLocation;
	var rectBoundsCL:ConstantLocation;
	var rectAttribCL:ConstantLocation;
	var gradColorsCL:ConstantLocation;
	var gradAttribCL:ConstantLocation;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_3X);
	}

	override inline function getUniforms() {
		transformOriginCL = pipeline.getConstantLocation("uTransformOrigin");
		scaleRotationCL = pipeline.getConstantLocation("uScaleRotation");
		resolutionCL = pipeline.getConstantLocation("uResolution");
		rectBoundsCL = pipeline.getConstantLocation("uRectBounds");
		rectAttribCL = pipeline.getConstantLocation("uRectAttrib");
		gradColorsCL = pipeline.getConstantLocation("uGradColors");
		gradAttribCL = pipeline.getConstantLocation("uGradAttrib");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setFloat4(resolutionCL, target.width, target.height, SUI.scene.width, SUI.scene.height);
		target.g4.setFloats(transformOriginCL, uniforms[0]);
		target.g4.setFloats(scaleRotationCL, uniforms[1]);
		target.g4.setFloats(rectBoundsCL, uniforms[2]);
		target.g4.setFloats(rectAttribCL, uniforms[3]);
		target.g4.setFloats(gradColorsCL, uniforms[4]);
		target.g4.setFloats(gradAttribCL, uniforms[5]);
	}
}
