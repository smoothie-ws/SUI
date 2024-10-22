package sui.core.shaders;

import kha.Canvas;
import kha.Shaders;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.ConstantLocation;
// sui
import sui.Color;

class EmissionShader {
	var pipeline:PipelineState;

	public var sizeID:ConstantLocation;
	public var offsetID:ConstantLocation;
	public var colorID:ConstantLocation;
	public var outerID:ConstantLocation;
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
		offsetID = pipeline.getConstantLocation("offset");
		colorID = pipeline.getConstantLocation("color");
		outerID = pipeline.getConstantLocation("outer");
		qualityID = pipeline.getConstantLocation("quality");
		resolutionID = pipeline.getConstantLocation("resolution");
	}

	public function apply(buffer:Canvas, size:Float, offsetX:Float, offsetY:Float, color:Color, outer:Bool, quality:Int) {
		buffer.g2.pipeline = pipeline;
		buffer.g4.setPipeline(pipeline);
		buffer.g4.setFloat(sizeID, size);
		buffer.g4.setFloat2(offsetID, offsetX, offsetY);
		buffer.g4.setFloat4(colorID, color.R / 255, color.G / 255, color.B / 255, color.A / 255);
		buffer.g4.setBool(outerID, outer);
		buffer.g4.setInt(qualityID, quality);
		buffer.g4.setFloat2(resolutionID, SUI.options.width, SUI.options.height);
	}
}
