package sui.core.shaders;

import kha.Image;
import kha.Shaders;
import kha.graphics4.Graphics;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;

class Shader {
	public var pipeline:PipelineState;

	public function new() {}

	public function getUniforms() {}

	public function setUniforms(g4:Graphics, args:Dynamic) {}

	public function compile(?frag:FragmentShader, ?vert:VertexShader) {
		frag = frag == null ? Shaders.painter_image_frag : frag;
		vert = vert == null ? Shaders.painter_image_vert : vert;

		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float32_3X);
		structure.add("vertexUV", VertexData.Float32_2X);
		structure.add("vertexColor", VertexData.UInt8_4X_Normalized);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;

		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = InverseSourceAlpha;

		pipeline.compile();

		getUniforms();
	}

	public function apply(buffer:Image, args:Dynamic) {
		buffer.g2.pipeline = pipeline;
		buffer.g4.setPipeline(pipeline);

		setUniforms(buffer.g4, args);
	}
}
