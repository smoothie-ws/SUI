package sui.stage2d.batches;

import kha.Canvas;
import kha.math.FastVector3;
import kha.arrays.Uint32Array;
import kha.arrays.Float32Array;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.DeferredRenderer;
import sui.stage2d.graphics.MapBatch;
import sui.stage2d.objects.Sprite;

using sui.core.utils.ArrayExt;

@:allow(sui.stage2d.Stage2D, sui.stage2d.objects.Sprite, sui.stage2d.graphics.RenderPath)
class SpriteBatch {
	#if (SUI_STAGE2D_BATCHING)
	@readonly public var sprites:Array<Sprite> = [];
	public var shadowVerts(get, never):Array<FastVector3>;
	@readonly public var gbuffer:MapBatch = new MapBatch(512, 4);

	inline function get_shadowVerts():Array<FastVector3> {
		var sv:Array<FastVector3> = [];
		for (sprite in sprites) {
			if (!sprite.shadowCasting)
				continue;
			for (sVert in sprite.shadowVerts)
				sv.push({x: sVert.x, y: sVert.y, z: sprite.shadowOpacity});
		}
		return sv;
	}

	@readonly var zArr:Float32Array = new Float32Array(64);
	@readonly var blendModeArr:Uint32Array = new Uint32Array(64);

	@readonly var vertData:Float32Array;
	@readonly var indData:Uint32Array;
	@readonly var vertices:VertexBuffer;
	@readonly var indices:IndexBuffer;

	public inline function new() {}

	inline function lock() {
		vertData = vertices.lock();
	}

	inline function unlock() {
		vertices.unlock();
	}

	inline function add(sprite:Sprite) {
		sprite.batch = this;
		sprites.push(sprite);

		var vertCount = 0;
		if (vertices != null) {
			vertCount = vertices.count();
			vertices.delete();
		}
		var indCount = 0;
		if (indices != null) {
			indCount = indices.count();
			indices.delete();
		}
		var vertOffset = vertCount * DeferredRenderer.geometry.structSize;
		sprite.vertOffset = vertOffset;

		vertices = new VertexBuffer(vertCount + 4, DeferredRenderer.geometry.structure, StaticUsage);
		indices = new IndexBuffer(indCount + 6, StaticUsage);

		var vert = vertices.lock();
		for (i in 0...vertData?.length)
			vert[i] = vertData[i];

		// init sprite UV
		vert[vertOffset + 3] = 0;
		vert[vertOffset + 4] = 0;

		vert[vertOffset + 8] = 0;
		vert[vertOffset + 9] = 1;

		vert[vertOffset + 13] = 1;
		vert[vertOffset + 14] = 1;

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

		vertData = vert;
		indData = ind;
	}

	#if SUI_STAGE2D_SHADING_DEFERRED
	inline function drawGeometry(target:Canvas) {
		unlock();
		DeferredRenderer.geometry.draw(target, vertices, indices, [
			gbuffer[0],
			gbuffer[1],
			gbuffer[2],
			gbuffer[3],
			zArr,
			gbuffer.packsCount,
			blendModeArr
		]);
		lock();
	}
	#end
	#end
}
