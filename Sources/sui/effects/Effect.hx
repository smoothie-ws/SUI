package sui.effects;

import kha.Image;
import kha.Shaders;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.BlendingFactor;
import kha.graphics4.FragmentShader;

@:structInit
class Effect {
	var shader:FragmentShader = null;
	var pipeline:PipelineState = null;

	public function new() {}

	function getUniforms() {}

	function setUniforms(buffer:Image) {}

	public function compile() {
		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float32_3X);
		structure.add("vertexUV", VertexData.Float32_2X);
		structure.add("vertexColor", VertexData.UInt8_4X_Normalized);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.painter_image_vert;
		pipeline.fragmentShader = Shaders.blur_frag;

		pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		pipeline.compile();
		getUniforms();
	}

	public function apply(buffer:Image) {
		buffer.g2.pipeline = pipeline;
		buffer.g4.setPipeline(pipeline);
		setUniforms(buffer);
	}
}
