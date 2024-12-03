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
	var gMapsTU:TextureUnit;
	var gMapsCountCL:ConstantLocation;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertData", VertexData.Float32_4X);
		structure.add("vertUV", VertexData.Float32_2X);
	}

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.colorAttachmentCount = 4;
		pipeline.colorAttachments = [RGBA32, RGBA32, RGBA32, RGBA32];
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		gMapsTU = pipeline.getTextureUnit("gMaps");
		gMapsCountCL = pipeline.getConstantLocation("gMapsCount");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(gMapsTU, uniforms[0]);
		target.g4.setInt(gMapsCountCL, uniforms[1]);
	}
}
