package sui.core.graphics;

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
	public var vertData:Array<Array<Float>> = [[0., 0.], [1., 0.], [1., 1.], [0., 1.]];

	var structure:VertexStructure;
	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	function getUniforms() {}

	function setUniforms(g4:Graphics) {}

	function initStructure() {
		structure.add("vertCoord", VertexData.Float32_2X);
	}

	inline function setVertices() {
		var v = vertices.lock();
		for (i in 0...vertData.length) {
			var vert = vertData[i];
			for (j in 0...vert.length)
				v[i * vert.length + j] = vert[j];
		}
		vertices.unlock();
	}

	public inline function compile(vert:VertexShader, frag:FragmentShader) {
		structure = new VertexStructure();
		initStructure();

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

		vertices = new VertexBuffer(4, structure, Usage.DynamicUsage);

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
		setVertices();
		target.g4.setPipeline(pipeline);
		target.g4.setVertexBuffer(vertices);
		target.g4.setIndexBuffer(indices);
		setUniforms(target.g4);
		target.g4.drawIndexedVertices();
	}
}
