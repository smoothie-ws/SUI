package sui.core.shaders;

import kha.Canvas;
import kha.Shaders;
import kha.arrays.Float32Array;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

class Shader2D {
	var pipeline:PipelineState;
	var vertData:VertData;

	function new(?vertData:VertData) {
		if (vertData == null)
			vertData = [
				{coordX: -1, coordY: -1},
				{coordX: 1, coordY: -1},
				{coordX: 1, coordY: 1},
				{coordX: -1, coordY: 1}
			];
		this.vertData = vertData;
	}

	function getUniforms() {}

	function setUniforms() {}

	function initStructure(structure:VertexStructure) {
		structure.add("vertCoord", VertexData.Float32_2X);
	}

	public inline function compile(vert:VertexShader, frag:FragmentShader) {
		// init structure
		var structure = new VertexStructure();
		initStructure(structure);

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
		vertices = new VertexBuffer(4, structure, Usage.DynamicUsage);

		// init indices
		indices = new IndexBuffer(6, Usage.StaticUsage);
		var ind = indices.lock();
		var k = 0;
		for (i in 1...3) {
			ind[k++] = 0;
			ind[k++] = i;
			ind[k++] = i + 1;
		}
		indices.unlock();

		getUniforms();
	}

	function setVertice(vertArray:Float32Array, vertIndex:Int, vert:Vert) {
		vertArray[vertIndex * 2 + 0] = vert.coordX;
		vertArray[vertIndex * 2 + 1] = vert.coordY;
	}

	inline function setVertices():Void {
		var vertArray = vertices.lock();
		for (vert in vertData)
			setVertice(vertArray, vertIndex, vert);
		vertices.unlock();
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

abstract VertData(Array<Vert>) from Array<Vert> to Array<Vert> {}

@:structInit
class Vert {
	public var coordX:Float;
	public var coordY:Float;
}
