package sui.core.graphics.shaders.deferred;

import kha.Canvas;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;
// sui
import sui.stage2d.GeometryMap;
import sui.stage2d.objects.Light;

class LightingPass extends Shader2D {
	static var albedoTU:TextureUnit;
	static var emissionTU:TextureUnit;
	static var normalTU:TextureUnit;
	static var ormTU:TextureUnit;
	static var shadowsTU:TextureUnit;

	static var lightPosCL:ConstantLocation;
	static var lightColorCL:ConstantLocation;
	static var lightAttribCL:ConstantLocation;

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		ormTU = pipeline.getTextureUnit("ormMap");
		normalTU = pipeline.getTextureUnit("normalMap");
		albedoTU = pipeline.getTextureUnit("albedoMap");
		shadowsTU = pipeline.getTextureUnit("shadowMap");
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
		target.g4.setTexture(shadowsTU, uniforms[4]);
		target.g4.setFloat3(lightPosCL, uniforms[5], uniforms[6], uniforms[7]);
		target.g4.setFloat3(lightColorCL, uniforms[8], uniforms[9], uniforms[10]);
		target.g4.setFloat2(lightAttribCL, uniforms[11], uniforms[12]);
	}
}
