package sui.core.shaders;

import kha.Canvas;
import kha.graphics4.Usage;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexShader;

class Shader2D {
	public var pipeline:PipelineState;
	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	function getUniforms() {}

	function setUniforms(g4:Graphics) {}

	public inline function compile(vert:VertexShader, frag:FragmentShader) {
		// init structure
		var structure = new VertexStructure();
		structure.add("vertCoord", VertexData.Float32_2X);

		// init pipeline
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();

		// init vertices
		vertices = new VertexBuffer(4, structure, Usage.StaticUsage);
		var v = vertices.lock();
		v[0] = 0.;
		v[1] = 0.;
		v[2] = 1.;
		v[3] = 0.;
		v[4] = 1.;
		v[5] = 1.;
		v[6] = 0.;
		v[7] = 1.;
		vertices.unlock();

		// init indices
		indices = new IndexBuffer(6, Usage.StaticUsage);
		var i = indices.lock();
		i[0] = 0;
		i[1] = 1;
		i[2] = 2;
		i[3] = 2;
		i[4] = 3;
		i[5] = 0;
		indices.unlock();

		getUniforms();
	}

	public inline function apply(target:Canvas):Void {
		target.g4.setPipeline(pipeline);
		target.g4.setVertexBuffer(vertices);
		target.g4.setIndexBuffer(indices);
		setUniforms(target.g4);
		target.g4.drawIndexedVertices();
	}
}
