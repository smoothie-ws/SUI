package sui.stage2d.batches;

import kha.Canvas;
import kha.arrays.Int32Array;
import kha.arrays.Uint32Array;
import kha.arrays.Float32Array;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.DeferredRenderer;
import sui.stage2d.graphics.MapBatch;
import sui.stage2d.objects.Sprite;

using sui.core.utils.ArrayExt;

@:allow(sui.stage2d.Stage2D)
@:allow(sui.stage2d.objects.Sprite)
class SpriteBatch {
	public var sprites:Array<Sprite> = [];
	public var gbuffer:MapBatch = new MapBatch(512, 4);

	var blendModes:Int32Array = new Int32Array(64);

	@readonly var vertData:Float32Array;
	@readonly var indData:Uint32Array;
	@readonly var vertices:VertexBuffer;
	@readonly var indices:IndexBuffer;

	public inline function new() {}

	public inline function lock() {
		vertData = vertices.lock();
	}

	public inline function unlock() {
		vertices.unlock();
	}

	public inline function add(sprite:Sprite) {
		sprite.batch = this;
		sprite.instanceID = sprites.length;
		gbuffer.extend();

		var structLength = 6;
		var vertCount = sprites.length * 4;
		var indCount = sprites.length * 6;
		var vertOffset = vertCount * structLength;

		vertices?.delete();
		vertices = new VertexBuffer(vertCount + 4, DeferredRenderer.geometry.structure, StaticUsage);
		indices?.delete();
		indices = new IndexBuffer(indCount + 6, StaticUsage);

		var vert = vertices.lock();
		for (i in 0...vertData?.length)
			vert[i] = vertData[i];

		vert[vertOffset + 2] = sprite.z;
		vert[vertOffset + 3] = sprite.instanceID;
		vert[vertOffset + 4] = 0;
		vert[vertOffset + 5] = 0;

		vert[vertOffset + 8] = sprite.z;
		vert[vertOffset + 9] = sprite.instanceID;
		vert[vertOffset + 10] = 0;
		vert[vertOffset + 11] = 1;

		vert[vertOffset + 14] = sprite.z;
		vert[vertOffset + 15] = sprite.instanceID;
		vert[vertOffset + 16] = 1;
		vert[vertOffset + 17] = 1;

		vert[vertOffset + 20] = sprite.z;
		vert[vertOffset + 21] = sprite.instanceID;
		vert[vertOffset + 22] = 1;
		vert[vertOffset + 23] = 0;

		var ind = indices.lock();
		for (i in 0...indData?.length)
			ind[i] = indData[i];

		ind[indCount + 0] = vertCount + 0;
		ind[indCount + 1] = vertCount + 1;
		ind[indCount + 2] = vertCount + 2;
		ind[indCount + 3] = vertCount + 0;
		ind[indCount + 4] = vertCount + 2;
		ind[indCount + 5] = vertCount + 3;
		indices.unlock();

		sprites.push(sprite);
		vertData = vert;
		indData = ind;
	}

	public inline function drawGeometry(target:Canvas) {
		unlock();
		DeferredRenderer.geometry.draw(target, vertices, indices, [
			gbuffer[0],
			gbuffer[1],
			gbuffer[2],
			gbuffer[3],
			sprites.length,
			blendModes
		]);
		lock();
	}
}
