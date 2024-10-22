package sui.core.shaders;

import kha.Canvas;
import kha.Shaders;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.ConstantLocation;

class BlurShader {
	var pipeline:PipelineState;

	public var sizeID:ConstantLocation;
	public var qualityID:ConstantLocation;
	public var resolutionID:ConstantLocation;

	public function new() {}

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
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;

		pipeline.compile();

		sizeID = pipeline.getConstantLocation("size");
		qualityID = pipeline.getConstantLocation("quality");
		resolutionID = pipeline.getConstantLocation("resolution");
	}

	public function apply(buffer:Canvas, size:Float, quality:Int) {
		buffer.g2.pipeline = pipeline;
		buffer.g4.setPipeline(pipeline);
		buffer.g4.setFloat(sizeID, size);
		buffer.g4.setInt(qualityID, quality);
		buffer.g4.setFloat2(resolutionID, SUI.options.width, SUI.options.height);
	}
}
