package sui.stage2d.objects;

import kha.Color;
import kha.FastFloat;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;

@:structInit
@:allow(sui.stage2d.Stage2D)
class MeshObject extends Object {
	public var albedo:Color = Color.fromFloats(0.85, 0.85, 0.85);
	public var emission:Color = Color.fromFloats(0.0, 0.0, 0.0);
	public var normal:Color = Color.fromFloats(0.5, 0.5, 1.0);
	public var orm:Color = Color.fromFloats(0.85, 0.85, 0.85); // [occlusion, metalness, roughness]
	public var shaded:Bool = true;

	@readonly public var indices:IndexBuffer;
	@readonly public var vertices:VertexBuffer;
	@readonly public var vertexCount:Int;
	@readonly public var structLength:Int;

	public var opacity:FastFloat = 1.0;
	public var isCastingShadows:Bool = true;

	public function new(vertexCount:Int) {
		super();
		this.vertexCount = vertexCount;
	}

	function init() {
		var structure = new VertexStructure();
		structure.add("vertCoord", VertexData.Float32_3X);
		structLength = 3;

		vertices = new VertexBuffer(vertexCount, structure, StaticUsage);
		indices = new IndexBuffer((vertexCount - 2) * 3, StaticUsage);

		var ind = indices.lock();
		for (i in 0...vertexCount - 2) {
			ind[i * 3 + 0] = 0;
			ind[i * 3 + 1] = i + 1;
			ind[i * 3 + 2] = i + 2;
		}
		indices.unlock();
	}
}
