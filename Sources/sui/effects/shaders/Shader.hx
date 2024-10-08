package sui.effects.shaders;

import kha.Image;
import kha.Shaders;
import kha.math.FastVector2;
import kha.graphics4.Graphics;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.BlendingFactor;
import kha.graphics4.FragmentShader;
import kha.graphics4.ConstantLocation;

class Shader {
	public var shader:FragmentShader;
	public var pipeline:PipelineState;
	public var resolutionID:ConstantLocation;

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
		resolutionID = pipeline.getConstantLocation("resolution");
	}

	public function apply(buffer:Image, args:Dynamic) {
		buffer.g2.pipeline = pipeline;
		buffer.g4.setPipeline(pipeline);

		setUniforms(buffer.g4, args);
		buffer.g4.setVector2(resolutionID, new FastVector2(SUI.options.width, SUI.options.height));
	}
}
