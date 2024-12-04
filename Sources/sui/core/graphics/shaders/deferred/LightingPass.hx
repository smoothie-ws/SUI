package sui.core.graphics.shaders.deferred;

import kha.Canvas;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

class LightingPass extends Shader2D {
	static var albedoTU:TextureUnit;
	static var emissionTU:TextureUnit;
	static var normalTU:TextureUnit;
	static var ormTU:TextureUnit;

	static var lightPosCL:ConstantLocation;
	static var lightColorCL:ConstantLocation;
	static var lightAttribCL:ConstantLocation;

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.blendOperation = Add;
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = BlendOne;
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		ormTU = pipeline.getTextureUnit("ormMap");
		normalTU = pipeline.getTextureUnit("normalMap");
		albedoTU = pipeline.getTextureUnit("albedoMap");
		emissionTU = pipeline.getTextureUnit("emissionMap");

		lightPosCL = pipeline.getConstantLocation("lightPos");
		lightColorCL = pipeline.getConstantLocation("lightColor");
		lightAttribCL = pipeline.getConstantLocation("lightAttrib");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(albedoTU, uniforms[0]);
		target.g4.setTexture(emissionTU, uniforms[1]);
		target.g4.setTexture(normalTU, uniforms[2]);
		target.g4.setTexture(ormTU, uniforms[3]);
		target.g4.setFloat3(lightPosCL, uniforms[4], uniforms[5], uniforms[6]);
		target.g4.setFloat3(lightColorCL, uniforms[7], uniforms[8], uniforms[9]);
		target.g4.setFloat2(lightAttribCL, uniforms[10], uniforms[11]);
	}
}
