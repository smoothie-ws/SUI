package sui.stage2d.batches;

import kha.Canvas;
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

	var zArr:Float32Array = new Float32Array(64);
	var blendModeArr:Uint32Array = new Uint32Array(64);

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
		if (sprites.length > 0)
			gbuffer.extend();

		var vertCount = sprites.length * 4;
		var indCount = sprites.length * 6;
		var vertOffset = vertCount * DeferredRenderer.geometry.structSize;

		vertices?.delete();
		vertices = new VertexBuffer(vertCount + 4, DeferredRenderer.geometry.structure, StaticUsage);
		indices?.delete();
		indices = new IndexBuffer(indCount + 6, StaticUsage);

		var vert = vertices.lock();
		for (i in 0...vertData?.length)
			vert[i] = vertData[i];

		vert[vertOffset + 2] = sprite.instanceID;
		vert[vertOffset + 3] = 0;
		vert[vertOffset + 4] = 0;

		vert[vertOffset + 7] = sprite.instanceID;
		vert[vertOffset + 8] = 0;
		vert[vertOffset + 9] = 1;

		vert[vertOffset + 12] = sprite.instanceID;
		vert[vertOffset + 13] = 1;
		vert[vertOffset + 14] = 1;

		vert[vertOffset + 17] = sprite.instanceID;
		vert[vertOffset + 18] = 1;
		vert[vertOffset + 19] = 0;

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
			zArr,
			sprites.length,
			blendModeArr
		]);
		lock();
	}
}
