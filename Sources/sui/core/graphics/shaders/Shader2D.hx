package sui.core.graphics.shaders;

import kha.Canvas;
import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexShader;

class Shader2D {
	public var pipeline:PipelineState;
	public var structure:VertexStructure;

	public function new() {}

	public inline function compile(vert:VertexShader, frag:FragmentShader) {
		initStructure();
		initPipeline(vert, frag);
		getUniforms();
	}

	function initStructure() {
		structure = new VertexStructure();
		structure.add("vertCoord", VertexData.Float32_2X);
	}

	function initPipeline(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();
	}

	function getUniforms() {}

	function setUniforms(target:Canvas, ?uniforms:Dynamic) {}

	public inline function draw(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, ?uniforms:Dynamic):Void {
		target.g4.setPipeline(pipeline);
		target.g4.setVertexBuffer(vertices);
		target.g4.setIndexBuffer(indices);
		setUniforms(target, uniforms);
		target.g4.drawIndexedVertices();
	}
}