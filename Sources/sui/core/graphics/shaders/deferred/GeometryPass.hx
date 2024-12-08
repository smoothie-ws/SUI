package sui.core.graphics.shaders.deferred;

import kha.Canvas;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

class GeometryPass extends Shader2D {
	var albedoMapsTU:TextureUnit;
	var emissionMapsTU:TextureUnit;
	var normalMapsTU:TextureUnit;
	var ormMapsTU:TextureUnit;
	var zArrCL:ConstantLocation;
	var instancesCountCL:ConstantLocation;
	var blendModeArrCL:ConstantLocation;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertData", VertexData.Float32_3X);
		structure.add("vertUV", VertexData.Float32_2X);
	}

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.depthWrite = true;
		pipeline.depthStencilAttachment = DepthOnly;
		pipeline.colorAttachmentCount = 4;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		albedoMapsTU = pipeline.getTextureUnit("albedoMap");
		emissionMapsTU = pipeline.getTextureUnit("emissionMap");
		normalMapsTU = pipeline.getTextureUnit("normalMap");
		ormMapsTU = pipeline.getTextureUnit("ormMap");
		zArrCL = pipeline.getConstantLocation('zArr');
		instancesCountCL = pipeline.getConstantLocation("instancesCount");
		blendModeArrCL = pipeline.getConstantLocation("blendModeArr");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(albedoMapsTU, uniforms[0]);
		target.g4.setTexture(emissionMapsTU, uniforms[1]);
		target.g4.setTexture(normalMapsTU, uniforms[2]);
		target.g4.setTexture(ormMapsTU, uniforms[3]);
		target.g4.setFloats(zArrCL, uniforms[4]);
		target.g4.setInt(instancesCountCL, uniforms[5]);
		target.g4.setInts(blendModeArrCL, uniforms[6]);
		pipeline.depthMode = Greater;
	}
}
