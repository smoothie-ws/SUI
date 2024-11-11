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
	var pipeline:PipelineState;
	var structure:VertexStructure;
	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	public final inline function compile(vert:VertexShader, frag:FragmentShader) {
		initStructure();
		initPipeline(vert, frag);
		initVertices();
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

	function initVertices() {
		vertices = new VertexBuffer(4, structure, Usage.StaticUsage);
		var v = vertices.lock();
		v[0] = -1;
		v[1] = -1;
		v[2] = -1;
		v[3] = 1;
		v[4] = 1;
		v[5] = 1;
		v[6] = 1;
		v[7] = -1;
		vertices.unlock();

		indices = new IndexBuffer(6, Usage.StaticUsage);
		var ind = indices.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 2;
		ind[4] = 3;
		ind[5] = 0;
		indices.unlock();
	}

	function getUniforms() {}

	function setUniforms(g4:Graphics) {}

	public final inline function apply(target:Canvas):Void {
		target.g4.setPipeline(pipeline);
		target.g4.setVertexBuffer(vertices);
		target.g4.setIndexBuffer(indices);
		setUniforms(target.g4);
		target.g4.scissor(0, 0, SUI.window.width, SUI.window.height);
		target.g4.drawIndexedVertices();
	}
}
