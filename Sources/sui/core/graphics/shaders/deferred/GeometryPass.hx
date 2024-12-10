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
	var albedoMapTU:TextureUnit;
	var emissionMapTU:TextureUnit;
	var normalMapTU:TextureUnit;
	var ormMapTU:TextureUnit;
	var blendModeCL:ConstantLocation;
	#if SUI_STAGE2D_BATCHING
	var instancesCountCL:ConstantLocation;
	#end

	override inline function initStructure() {
		structure = new VertexStructure();
		#if SUI_STAGE2D_BATCHING
		structure.add("vertData", VertexData.Float32_4X);
		#else
		structure.add("vertPos", VertexData.Float32_3X);
		#end
		structure.add("vertUV", VertexData.Float32_2X);
	}

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.depthWrite = true;
		pipeline.depthStencilAttachment = DepthOnly;
		pipeline.colorAttachmentCount = 3;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		albedoMapTU = pipeline.getTextureUnit("albedoMap");
		emissionMapTU = pipeline.getTextureUnit("emissionMap");
		normalMapTU = pipeline.getTextureUnit("normalMap");
		ormMapTU = pipeline.getTextureUnit("ormMap");
		blendModeCL = pipeline.getConstantLocation("blendMode");
		#if SUI_STAGE2D_BATCHING
		instancesCountCL = pipeline.getConstantLocation("instancesCount");
		#end
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(albedoMapTU, uniforms[0]);
		target.g4.setTexture(emissionMapTU, uniforms[1]);
		target.g4.setTexture(normalMapTU, uniforms[2]);
		target.g4.setTexture(ormMapTU, uniforms[3]);
		#if SUI_STAGE2D_BATCHING
		target.g4.setInt(instancesCountCL, uniforms[4]);
		target.g4.setInts(blendModeCL, uniforms[5]);
		#else
		target.g4.setInt(blendModeCL, uniforms[4]);
		#end
		pipeline.depthMode = Greater;
	}
}
