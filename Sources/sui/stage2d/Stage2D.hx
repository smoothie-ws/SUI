package sui.stage2d;

import kha.Image;
import kha.Canvas;
import kha.FastFloat;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.DeferredRenderer;
import sui.elements.DrawableElement;
import sui.stage2d.batches.MeshBatch;
import sui.stage2d.objects.Object;
import sui.stage2d.objects.MeshObject;

using sui.core.utils.ArrayExt;

class Stage2D extends DrawableElement {
	public var backbuffer:Image;
	public var gbuffer:GBuffer;

	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	var batches:Array<MeshBatch> = [];

	public function new(scene:Scene) {
		super(scene);

		backbuffer = Image.createRenderTarget(1, 1);
		gbuffer = new GBuffer(1, 1);

		vertices = new VertexBuffer(4, DeferredRenderer.lighting.structure, StaticUsage);
		var vert = vertices.lock();
		vert[0] = -1;
		vert[1] = -1;
		vert[2] = -1;
		vert[3] = 1;
		vert[4] = 1;
		vert[5] = 1;
		vert[6] = 1;
		vert[7] = -1;
		vertices.unlock();

		indices = new IndexBuffer(6, StaticUsage);
		var ind = indices.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 3;
		ind[4] = 2;
		ind[5] = 0;
		indices.unlock();

		left.addPositionListener(setLeft);
		top.addPositionListener(setTop);
		right.addPositionListener(setRight);
		bottom.addPositionListener(setBottom);
	}

	inline function resizeBuffers(width:FastFloat, height:FastFloat) {
		if (width > 0 && height > 0) {
			var w = Std.int(width);
			var h = Std.int(height);

			backbuffer = Image.createRenderTarget(w, h);
			gbuffer.resize(w, h);
		}
	}

	inline function setLeft(value:FastFloat) {
		resizeBuffers(width, height);
	}

	inline function setTop(value:FastFloat) {
		resizeBuffers(width, height);
	}

	inline function setRight(value:FastFloat) {
		resizeBuffers(width, height);
	}

	inline function setBottom(value:FastFloat) {
		resizeBuffers(width, height);
	}

	public inline function add(object:Object) {
		if (object is MeshObject) {
			var mesh:MeshObject = cast object;
			var lb = batches.last();

			if (lb is MeshBatch && lb.capacity < lb.meshes.length) {
				lb.add(mesh);
			} else {
				var b = new MeshBatch();
				b.add(mesh);
				batches.push(b);
			}
		}
	}

	override inline function draw(target:Canvas) {
		target.g2.end();

		// drawGeometry();

		// backbuffer.g2.begin(true);
		// for (light in lights) {
		// 	DeferredRenderer.lighting.draw(backbuffer, vertices, indices, [
		// 		gbuffer.albedo,
		// 		gbuffer.emission,
		// 		gbuffer.normal,
		// 		gbuffer.orm,
		// 		light.x,
		// 		light.y,
		// 		light.z,
		// 		light.color.R,
		// 		light.color.G,
		// 		light.color.B,
		// 		light.power,
		// 		light.radius
		// 	]);
		// 	// light.drawShadows(backbuffer, meshes);
		// }
		// backbuffer.g2.end();

		target.g2.begin(false);
		target.g2.drawImage(backbuffer, x, y);
	}

	inline function drawGeometry() {
		gbuffer.albedo.g4.begin([gbuffer.emission, gbuffer.normal, gbuffer.orm]);
		for (batch in batches)
			DeferredRenderer.geometry.draw(gbuffer.albedo, batch.vertices, batch.indices, [
				batch.gbuffer.albedo,
				batch.gbuffer.emission,
				batch.gbuffer.normal,
				batch.gbuffer.orm,
				batch.meshes.length
			]);
		gbuffer.albedo.g4.end();
	}
}
