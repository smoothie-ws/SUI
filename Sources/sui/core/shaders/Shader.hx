package sui.core.shaders;

import kha.Image;
import kha.Shaders;
import kha.graphics4.Graphics;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.BlendingFactor;
import kha.graphics4.FragmentShader;

class Shader {
	public var shader:FragmentShader;
	public var pipeline:PipelineState;

	public function getUniforms() {}

	public function setUniforms(g4:Graphics, args:Dynamic) {}

	public function compile(shader:FragmentShader) {
		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float32_3X);
		structure.add("vertexUV", VertexData.Float32_2X);
		structure.add("vertexColor", VertexData.UInt8_4X_Normalized);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.painter_image_vert;
		pipeline.fragmentShader = Shaders.blur_frag;
		pipeline.blendSource = BlendingFactor.SourceAlpha;
		pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		pipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
		pipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;

		pipeline.compile();

		getUniforms();
	}

	public function apply(buffer:Image, args:Dynamic) {
		buffer.g2.pipeline = pipeline;
		buffer.g4.setPipeline(pipeline);

		setUniforms(buffer.g4, args);
	}
}
