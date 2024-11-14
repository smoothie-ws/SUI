package sui.core.graphics.painters.shaders;

import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class RectPainterShader extends Shader2D {
	var resolutionCL:ConstantLocation;
	var transformOriginCL:ConstantLocation;
	var scaleRotationCL:ConstantLocation;
	var rectRadiusCL:ConstantLocation;
	var rectBoundsCL:ConstantLocation;
	var rectColorCL:ConstantLocation;
	var rectSoftnessCL:ConstantLocation;
	var bordColorCL:ConstantLocation;
	var bordSoftnessCL:ConstantLocation;
	var bordThicknessCL:ConstantLocation;
	var emisColorCL:ConstantLocation;
	var emisOffsetCL:ConstantLocation;
	var emisSoftnessCL:ConstantLocation;
	var emisSizeCL:ConstantLocation;
	var opacityCL:ConstantLocation;
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
		rectRadiusCL = pipeline.getConstantLocation("uRectRadius");
		rectBoundsCL = pipeline.getConstantLocation("uRectBounds");
		rectColorCL = pipeline.getConstantLocation("uRectColor");
		rectSoftnessCL = pipeline.getConstantLocation("uRectSoftness");
		bordColorCL = pipeline.getConstantLocation("uBordColor");
		bordSoftnessCL = pipeline.getConstantLocation("uBordSoftness");
		bordThicknessCL = pipeline.getConstantLocation("uBordThickness");
		emisColorCL = pipeline.getConstantLocation("uEmisColor");
		emisOffsetCL = pipeline.getConstantLocation("uEmisOffset");
		emisSoftnessCL = pipeline.getConstantLocation("uEmisSoftness");
		emisSizeCL = pipeline.getConstantLocation("uEmisSize");
		opacityCL = pipeline.getConstantLocation("uOpacity");
		gradColorsCL = pipeline.getConstantLocation("uGradColors");
		gradAttribCL = pipeline.getConstantLocation("uGradAttrib");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setFloat4(resolutionCL, target.width, target.height, SUI.window.width, SUI.window.height);
		target.g4.setFloats(transformOriginCL, uniforms[0]);
		target.g4.setFloats(scaleRotationCL, uniforms[1]);
		target.g4.setFloats(rectRadiusCL, uniforms[2]);
		target.g4.setFloats(rectBoundsCL, uniforms[3]);
		target.g4.setFloats(rectColorCL, uniforms[4]);
		target.g4.setFloats(rectSoftnessCL, uniforms[5]);
		target.g4.setFloats(bordColorCL, uniforms[6]);
		target.g4.setFloats(bordSoftnessCL, uniforms[7]);
		target.g4.setFloats(bordThicknessCL, uniforms[8]);
		target.g4.setFloats(emisColorCL, uniforms[9]);
		target.g4.setFloats(emisOffsetCL, uniforms[10]);
		target.g4.setFloats(emisSoftnessCL, uniforms[11]);
		target.g4.setFloats(emisSizeCL, uniforms[12]);
		target.g4.setFloats(opacityCL, uniforms[13]);
		target.g4.setFloats(gradColorsCL, uniforms[14]);
		target.g4.setFloats(gradAttribCL, uniforms[15]);
	}
}
