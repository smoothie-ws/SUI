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
	public var gbuffer:GBufferBatch;

	@readonly public var capacity:Int;

	@readonly var vertices:VertexBuffer;
	@readonly var indices:IndexBuffer;

	public inline function new(capacity:Int = 64) {
		gbuffer = new GBufferBatch(512, 512, capacity);
		vertices = new VertexBuffer(capacity, DeferredRenderer.geometry.structure, StaticUsage);
		indices = new IndexBuffer(capacity, StaticUsage);
	}

	public inline function add(mesh:MeshObject) {
		mesh.batch = this;
		mesh.instanceID = meshes.length;
		if (meshes.length > 0)
			mesh.vertOffset = meshes.last().vertOffset + meshes.last().vertCount;
		meshes.push(mesh);
	}
}
