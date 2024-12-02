package sui.stage2d.objects;

import kha.Image;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;

class Sprite extends MeshObject {
	public var albedoMap:Image = null;
	public var emissionMap:Image = null;
	public var normalMap:Image = null;
	public var ormMap:Image = null; // [occlusion, metalness, roughness]

	override inline function init() {
		var structure = new VertexStructure();
		structure.add("vertCoord", VertexData.Float32_3X);
		structure.add("vertUV", VertexData.Float32_2X);
		structLength = 5;

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
