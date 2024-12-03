package sui.stage2d.batches;

import sui.stage2d.objects.MeshObject;
import sui.core.graphics.DeferredRenderer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.stage2d.objects.Object;

class MeshBatch extends ObjectBatch {
	override inline function add(object:Object) {
		var n = objects.length;
		objects.push(object);
		var mesh:MeshObject = cast object;

		var indexOffset = indices.count();
		var vertexOffset = vertices.count();

		var newIndices = new IndexBuffer(indexOffset + (mesh.vertices.length - 2) * 3, StaticUsage);
		var newVertices = new VertexBuffer(vertexOffset + mesh.vertices.length, DeferredRenderer.geometry.structure, StaticUsage);

		var ind = newIndices.lock();
		var vert = newVertices.lock();
		
		var _ind = indices.lock();
		for (i in 0...indices.count()) {
			ind[i] = _ind[i];
		}
		indices.unlock();
		indices.delete();

		var _vert = vertices.lock();
		for (i in 0...vertices.count()) {
			vert[i] = _vert[i];
		}
		vertices.unlock();
		vertices.delete();

		for (i in 0...mesh.vertices.length - 2) {
			ind[indexOffset + i * 3 + 0] = vertexOffset;
			ind[indexOffset + i * 3 + 1] = vertexOffset + i + 1;
			ind[indexOffset + i * 3 + 2] = vertexOffset + i + 2;
		}

		for (i in 0...mesh.vertices.length) {
			vert[(vertexOffset + i) * 6 + 0] = mesh.vertices[i].pos.x;
			vert[(vertexOffset + i) * 6 + 1] = mesh.vertices[i].pos.y;
			vert[(vertexOffset + i) * 6 + 2] = mesh.z;
			vert[(vertexOffset + i) * 6 + 3] = n;
			vert[(vertexOffset + i) * 6 + 4] = mesh.vertices[i].uv.x;
			vert[(vertexOffset + i) * 6 + 5] = mesh.vertices[i].uv.y;
		}

		newIndices.unlock();
		newVertices.unlock();

		indices = newIndices;
		vertices = newVertices;
	}
}
