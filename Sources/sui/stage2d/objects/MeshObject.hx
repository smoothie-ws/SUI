package sui.stage2d.objects;

import kha.FastFloat;
import kha.graphics4.VertexStructure;
import kha.graphics5_.VertexBuffer;
import kha.graphics4.IndexBuffer;
// sui
import sui.stage2d.lighting.Light;

@:structInit
class MeshObject extends Object {
	public var indices:IndexBuffer;
	public var vertices:VertexBuffer;
	public var opacity:FastFloat = 1.0;
	public var structLength:Int;
	public var isCastingShadows:Bool = true;

	public function new(vertexCount:Int, structure:VertexStructure, structureLength:Int) {
		super();

		this.structLength = structureLength;
		this.vertices = new VertexBuffer(vertexCount, structure, StaticUsage);
		this.indices = new IndexBuffer((vertexCount - 2) * 3, StaticUsage);

		var ind = this.indices.lock();
		for (i in 0...vertexCount - 2) {
			ind[i * 3 + 0] = 0;
			ind[i * 3 + 1] = i + 1;
			ind[i * 3 + 2] = i + 2;
		}
		this.indices.unlock();
	}

	public inline function castShadows(light:Light) {
		var vert:Array<Float> = [];
		var ind:Array<Int> = [];

		var v = vertices.lock();
		var vertexCount = Std.int(v.length / structLength);

		var indOffset = 0;
		for (i in 0...vertexCount) {
			var x1 = v[i * structLength];
			var y1 = v[i * structLength + 1];
			var x2 = v[((i + 1) % vertexCount) * structLength];
			var y2 = v[((i + 1) % vertexCount) * structLength + 1];

			var normalX = y2 - y1;
			var normalY = x1 - x2;
			var lightVecX = light.position.x - x1;
			var lightVecY = light.position.y - y1;

			if (normalX * lightVecX + normalY * lightVecY > 0) {
				var shadowX1 = x1 - lightVecX * 100;
				var shadowY1 = y1 - lightVecY * 100;
				var shadowX2 = x2 - (light.position.x - x2) * 100;
				var shadowY2 = y2 - (light.position.y - y2) * 100;

				vert.push(x1);
				vert.push(y1);
				vert.push(opacity);

				vert.push(x2);
				vert.push(y2);
				vert.push(opacity);

				vert.push(shadowX1);
				vert.push(shadowY1);
				vert.push(opacity);

				vert.push(shadowX2);
				vert.push(shadowY2);
				vert.push(opacity);

				ind.push(indOffset);
				ind.push(indOffset + 1);
				ind.push(indOffset + 3);
				ind.push(indOffset + 3);
				ind.push(indOffset + 2);
				ind.push(indOffset);

				indOffset += 4;
			}
		}
		vertices.unlock();
		return {vertices: vert, indices: ind};
	}
}
