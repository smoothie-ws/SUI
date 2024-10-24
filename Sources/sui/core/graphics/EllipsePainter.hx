package sui.core.graphics;

import kha.Canvas;
import kha.Shaders;
import kha.graphics4.Usage;
import kha.graphics4.VertexData;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.ConstantLocation;
// sui
import sui.Color;

class EllipsePainter {
	static var pipeline:PipelineState;
	static var vertices:VertexBuffer;
	static var indices:IndexBuffer;

	static var colorID:ConstantLocation;
	static var resolutionID:ConstantLocation;
	static var smoothnessID:ConstantLocation;

	public function new() {}

	public function compile() {
		var structure = new VertexStructure();
		structure.add("vertData", VertexData.Float32_4X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.rect_vert;
		pipeline.fragmentShader = Shaders.ellipse_frag;
		pipeline.compile();

		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;

		colorID = pipeline.getConstantLocation("color");
		resolutionID = pipeline.getConstantLocation("resolution");
		smoothnessID = pipeline.getConstantLocation("smoothness");

		// init vertices
		vertices = new VertexBuffer(4, structure, Usage.StaticUsage);

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
	}

	function setVertices(vData:Array<Array<Float>>):Void {
		var vert = vertices.lock();
		for (i in 0...4)
			for (j in 0...vData[i].length)
				vert.set(i * vData[i].length + j, vData[i][j]);
		vertices.unlock();
	}
    
	public function fillEllipse(target:Canvas, x:Float, y:Float, w:Float, h:Float, color:Color, ?smoothness:Float = 2.):Void {
		var tW = target.width;
		var tH = target.height;

		var xL = (x / tW) * 2 - 1;
		var xR = (x + w) / tW * 2 - 1;
		var yT = (y / tH) * 2 - 1;
		var yB = (y + h) / tH * 2 - 1;
		
		setVertices([
			[xL, yT, 0, 0], 
			[xR, yT, 1, 0], 
			[xR, yB, 1, 1], 
			[xL, yB, 0, 1]
		]);

		target.g4.setPipeline(pipeline);
		target.g4.setVertexBuffer(vertices);
		target.g4.setIndexBuffer(indices);

		target.g4.setFloat(smoothnessID, smoothness);
		target.g4.setFloat2(resolutionID, SUI.options.width, SUI.options.height);
		target.g4.setFloat4(colorID, color.R / 255, color.G / 255, color.B / 255, color.A / 255);

		target.g4.drawIndexedVertices();
	}
}
