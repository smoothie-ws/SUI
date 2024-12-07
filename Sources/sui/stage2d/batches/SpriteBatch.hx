package sui.stage2d.batches;

import kha.arrays.Float32Array;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.stage2d.objects.Sprite;
import sui.core.graphics.DeferredRenderer;

using sui.core.utils.ArrayExt;

@:allow(sui.stage2d.Stage2D)
@:allow(sui.stage2d.objects.Sprite)
class SpriteBatch {
	public var sprites:Array<Sprite> = [];
	public var gbuffer:MapBatch = new MapBatch(1024, 1024, 4);

	@readonly var structLength:Int = 6;
	@readonly var vertData:Float32Array;
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
		sprites.push(sprite);

		var vertCount = vertices == null ? 0 : vertices.count();
		var indCount = indices == null ? 0 : indices.count();
		var vertOffset = vertCount * structLength;

		if (sprites.length > 1) {
			var _vert = vertices.lock();
			vertices.delete();
			var _ind = indices.lock();
			indices.delete();

			vertices = new VertexBuffer(vertCount + sprite.vertCount, DeferredRenderer.geometry.structure, StaticUsage);
			vertData = vertices.lock();

			for (i in 0..._vert.length)
				vertData[i] = _vert[i];

			for (i in 0...sprite.vertCount) {
				vertData[vertOffset + i * structLength + 2] = sprite.z;
				vertData[vertOffset + i * structLength + 3] = sprite.instanceID;
			}

			indices = new IndexBuffer(indCount + (sprite.vertCount - 2) * 3, StaticUsage);

			var ind = indices.lock();
			for (i in 0..._ind.length)
				ind[i] = _ind[i];

			ind[indCount + 0] = vertCount + 0;
			ind[indCount + 1] = vertCount + 1;
			ind[indCount + 2] = vertCount + 2;
			ind[indCount + 3] = vertCount + 0;
			ind[indCount + 4] = vertCount + 2;
			ind[indCount + 5] = vertCount + 3;
			indices.unlock();
		} else {
			vertices = new VertexBuffer(vertCount + sprite.vertCount, DeferredRenderer.geometry.structure, StaticUsage);
			vertData = vertices.lock();

			for (i in 0...sprite.vertCount) {
				vertData[vertOffset + i * structLength + 2] = sprite.z;
				vertData[vertOffset + i * structLength + 3] = sprite.instanceID;
			}

			indices = new IndexBuffer(indCount + (sprite.vertCount - 2) * 3, StaticUsage);
			var ind = indices.lock();
			ind[indCount + 0] = vertCount + 0;
			ind[indCount + 1] = vertCount + 1;
			ind[indCount + 2] = vertCount + 2;
			ind[indCount + 3] = vertCount + 0;
			ind[indCount + 4] = vertCount + 2;
			ind[indCount + 5] = vertCount + 3;
			indices.unlock();
		}
	}
}
