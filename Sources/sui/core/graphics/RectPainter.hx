package sui.core.graphics;

import kha.Image;
import kha.Shaders;
import kha.FastFloat;
import kha.graphics4.Usage;
import kha.graphics4.VertexData;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.ConstantLocation;
// sui
import sui.Color;

class RectPainter {
	static var pipeline:PipelineState;
	static var vertices:VertexBuffer;
	static var indices:IndexBuffer;

	static var xID:ConstantLocation;
	static var yID:ConstantLocation;
	static var wID:ConstantLocation;
	static var hID:ConstantLocation;

	static var colorID:ConstantLocation;
	static var radiusID:ConstantLocation;
	static var resolutionID:ConstantLocation;
	static var smoothnessID:ConstantLocation;

	public function new() {}

	public function compile() {
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.rect_vert;
		pipeline.fragmentShader = Shaders.rect_frag;
		pipeline.compile();

		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;

		xID = pipeline.getConstantLocation("x");
		yID = pipeline.getConstantLocation("y");
		wID = pipeline.getConstantLocation("width");
		hID = pipeline.getConstantLocation("height");

		colorID = pipeline.getConstantLocation("color");
		radiusID = pipeline.getConstantLocation("radius");
		resolutionID = pipeline.getConstantLocation("resolution");
		smoothnessID = pipeline.getConstantLocation("smoothness");

		// vertex pos
		var V = [[-1, -1, 0], [1, -1, 0], [1, 1, 0], [-1, 1, 0]];

		// init vertices
		var vertexCount = V.length;
		vertices = new VertexBuffer(vertexCount, structure, Usage.StaticUsage);
		var vert = vertices.lock();
		for (i in 0...vertexCount) {
			var vdata = V[i];
			for (j in 0...vdata.length) {
				vert.set(i * vdata.length + j, vdata[j]);
			}
		}
		vertices.unlock();

		// init indices
		var indexCount = (vertexCount - 2) * 3;
		indices = new IndexBuffer(indexCount, Usage.StaticUsage);
		var ind = indices.lock();
		var k = 0;
		for (i in 1...(vertexCount - 1)) {
			ind[k++] = 0;
			ind[k++] = i;
			ind[k++] = i + 1;
		}
		indices.unlock();
	}

	public function fillRect(target:Image, x:FastFloat, y:FastFloat, width:FastFloat, height:FastFloat, color:Color, ?radius:FastFloat = 10.,
			?smoothness:FastFloat = 2.):Void {
		target.g4.setPipeline(pipeline);
		target.g4.setVertexBuffer(vertices);
		target.g4.setIndexBuffer(indices);

		target.g4.setFloat(xID, x);
		target.g4.setFloat(yID, y);
		target.g4.setFloat(wID, width);
		target.g4.setFloat(hID, height);
		target.g4.setFloat(radiusID, radius);
		target.g4.setFloat3(colorID, color.R / 255, color.G / 255, color.B / 255);
		target.g4.setFloat(smoothnessID, 4.);
		target.g4.setFloat2(resolutionID, SUI.options.width, SUI.options.height);

		target.g4.drawIndexedVertices();
	}
}
