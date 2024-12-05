package sui.stage2d.batches;

import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.stage2d.objects.MeshObject;
import sui.core.graphics.DeferredRenderer;

using sui.core.utils.ArrayExt;

@:allow(sui.stage2d.Stage2D)
@:allow(sui.stage2d.objects.MeshObject)
class MeshBatch {
	public var meshes:Array<MeshObject> = [];
	public var gbuffer:GBufferBatch = null;

	@readonly var vertices:VertexBuffer;
	@readonly var indices:IndexBuffer;

	public inline function new() {
		gbuffer = new GBufferBatch();
	}

	public inline function add(mesh:MeshObject) {
		mesh.batch = this;
		mesh.instanceID = meshes.length;

		var vertOffset = 0;
		if (meshes.length > 0) {
			vertOffset = meshes.last().vertOffset + meshes.last().vertCount;
			mesh.vertOffset = vertOffset;
		}
		meshes.push(mesh);

		var vertCount = 0;
		for (mesh in meshes)
			vertCount += mesh.vertCount;

		gbuffer = new GBufferBatch(meshes.length);

		if (meshes.length > 0) {
			var _vert = vertices.lock();
			vertices.unlock();
			vertices.delete();

			vertices = new VertexBuffer(vertCount, DeferredRenderer.geometry.structure, StaticUsage);
			var vert = vertices.lock();
			for (i in 0..._vert.length)
				vert[i] = _vert[i];
			vertices.unlock();

			var _ind = indices.lock();
			indices.unlock();
			indices.delete();

			indices = new IndexBuffer((vertCount - 2) * 3, StaticUsage);
			var ind = indices.lock();
			for (i in 0..._ind.length)
				ind[i] = _ind[i];
			for (i in 0...mesh.vertCount - 2) {
				ind[vertOffset + i] = i;
				ind[vertOffset + i + 1] = i + 1;
				ind[vertOffset + i + 2] = i + 2;
			}
			indices.unlock();
		} else {
			vertices = new VertexBuffer(vertCount, DeferredRenderer.geometry.structure, StaticUsage);
			indices = new IndexBuffer((vertCount - 2) * 3, StaticUsage);
			var ind = indices.lock();
			for (i in 0...vertCount - 2) {
				ind[i] = i;
				ind[i + 1] = i + 1;
				ind[i + 2] = i + 2;
			}
			indices.unlock();
		}
	}
}
