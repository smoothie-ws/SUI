package sui.stage2d.batches;

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
	public var gbuffer:MapBatch = new MapBatch(512, 512, 4);

	@readonly var vertices:VertexBuffer;
	@readonly var indices:IndexBuffer;

	public inline function new() {}

	public inline function add(sprite:Sprite) {
		sprite.batch = this;
		sprite.instanceID = sprites.length;
		sprites.push(sprite);
		gbuffer.extend();

		if (sprites.length > 1) {
			var _vert = vertices.lock();
			vertices.delete();
			var _ind = indices.lock();
			indices.delete();

			vertices = new VertexBuffer(sprites.length * 4, DeferredRenderer.geometry.structure, StaticUsage);

			var vert = vertices.lock();
			for (i in 0..._vert.length)
				vert[i] = _vert[i];

			var offset = (sprites.length - 1) * 4 * 6;
			vert[offset + 2] = sprite.z;
			vert[offset + 3] = sprite.instanceID;
			vert[offset + 4] = 0;
			vert[offset + 5] = 0;

			vert[offset + 8] = sprite.z;
			vert[offset + 9] = sprite.instanceID;
			vert[offset + 10] = 0;
			vert[offset + 11] = 1;

			vert[offset + 14] = sprite.z;
			vert[offset + 15] = sprite.instanceID;
			vert[offset + 16] = 1;
			vert[offset + 17] = 1;

			vert[offset + 20] = sprite.z;
			vert[offset + 21] = sprite.instanceID;
			vert[offset + 22] = 1;
			vert[offset + 23] = 0;
			vertices.unlock();

			indices = new IndexBuffer(sprites.length * 6, StaticUsage);

			var ind = indices.lock();
			for (i in 0..._ind.length)
				ind[i] = _ind[i];
			var vc = (sprites.length - 1) * 4;
			var bi = (sprites.length - 1) * 6;
			ind[bi + 0] = vc + 0;
			ind[bi + 1] = vc + 1;
			ind[bi + 2] = vc + 2;
			ind[bi + 3] = vc + 0;
			ind[bi + 4] = vc + 2;
			ind[bi + 5] = vc + 3;
			indices.unlock();
		} else {
			vertices = new VertexBuffer(sprites.length * 4, DeferredRenderer.geometry.structure, StaticUsage);
			var vert = vertices.lock();
			vert[2] = sprite.z;
			vert[3] = sprite.instanceID;
			vert[4] = 0;
			vert[5] = 0;

			vert[8] = sprite.z;
			vert[9] = sprite.instanceID;
			vert[10] = 0;
			vert[11] = 1;

			vert[14] = sprite.z;
			vert[15] = sprite.instanceID;
			vert[16] = 1;
			vert[17] = 1;

			vert[20] = sprite.z;
			vert[21] = sprite.instanceID;
			vert[22] = 1;
			vert[23] = 0;
			vertices.unlock();

			indices = new IndexBuffer(sprites.length * 6, StaticUsage);
			var ind = indices.lock();
			ind[0] = 0;
			ind[1] = 1;
			ind[2] = 2;
			ind[3] = 0;
			ind[4] = 2;
			ind[5] = 3;
			indices.unlock();
		}
	}
}
