package sui.core.graphics.shaders;

import kha.Canvas;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

class DeferredRenderer extends Shader2D {
	static var ormdTU:TextureUnit;
	static var albedoTU:TextureUnit;
	static var normalTU:TextureUnit;
	static var shadowTU:TextureUnit;
	static var emissionTU:TextureUnit;

	static var lightPosCL:ConstantLocation;
	static var lightColorCL:ConstantLocation;
	static var lightAttribCL:ConstantLocation;

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.blendSource = SourceColor;
		pipeline.blendDestination = DestinationColor;
		pipeline.blendOperation = Add;
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		ormdTU = pipeline.getTextureUnit("ormdMap");
		normalTU = pipeline.getTextureUnit("normalMap");
		albedoTU = pipeline.getTextureUnit("albedoMap");
		shadowTU = pipeline.getTextureUnit("shadowMap");
		emissionTU = pipeline.getTextureUnit("emissionMap");

		lightPosCL = pipeline.getConstantLocation("lightPos");
		lightColorCL = pipeline.getConstantLocation("lightColor");
		lightAttribCL = pipeline.getConstantLocation("lightAttrib");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(ormdTU, uniforms[0]);
		target.g4.setTexture(albedoTU, uniforms[1]);
		target.g4.setTexture(normalTU, uniforms[2]);
		target.g4.setTexture(shadowTU, uniforms[3]);
		target.g4.setTexture(emissionTU, uniforms[4]);
		target.g4.setVector3(lightPosCL, uniforms[5]);
		target.g4.setFloat3(lightColorCL, uniforms[6], uniforms[7], uniforms[8]);
		target.g4.setFloat2(lightAttribCL, uniforms[9], uniforms[10]);
	}
}
