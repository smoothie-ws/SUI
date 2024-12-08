package sui.stage2d;

import kha.Color;
import kha.Image;
import kha.Canvas;
import kha.FastFloat;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.DeferredRenderer;
import sui.elements.DrawableElement;
import sui.stage2d.graphics.MapPack;
import sui.stage2d.batches.SpriteBatch;
import sui.stage2d.objects.Object;
import sui.stage2d.objects.Sprite;
import sui.stage2d.objects.Light;

using sui.core.utils.ArrayExt;

class Stage2D extends DrawableElement {
	public var backbuffer:Image;
	public var gbuffer:MapPack;

	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	var batches:Array<SpriteBatch> = [];
	var lights:Array<Light> = [];

	public function new(scene:Scene) {
		super(scene);

		backbuffer = Image.createRenderTarget(1, 1, RGBA32, DepthOnly, SUI.options.samplesPerPixel);
		gbuffer = new MapPack(1, 1, 4, RGBA32, DepthOnly, SUI.options.samplesPerPixel);

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
		var w = Std.int(width);
		var h = Std.int(height);

		backbuffer = Image.createRenderTarget(w, h);
		gbuffer.resize(w, h);
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
		if (object is Sprite) {
			var sprite:Sprite = cast object;
			var lb = batches.last();
			if (lb is SpriteBatch) {
				lb.add(sprite);
			} else {
				var b = new SpriteBatch();
				b.add(sprite);
				batches.push(b);
			}
		} else if (object is Light)
			lights.push(cast object);
	}

	override inline function draw(target:Canvas) {
		target.g2.end();

		gbuffer[0].g4.begin([gbuffer[1], gbuffer[2], gbuffer[3]]);
		gbuffer[0].g4.clear(Color.Transparent);
		for (batch in batches)
			batch.drawGeometry(gbuffer[0]);
		gbuffer[0].g4.end();

		backbuffer.g2.begin();
		for (light in lights) {
			DeferredRenderer.lighting.draw(backbuffer, vertices, indices, [
				gbuffer[0],
				gbuffer[1],
				gbuffer[2],
				gbuffer[3],
				light.x,
				light.y,
				light.z,
				light.color.R,
				light.color.G,
				light.color.B,
				light.power,
				light.radius
			]);
		}
		backbuffer.g2.end();

		target.g2.begin(false);
		target.g2.drawScaledImage(backbuffer, x, y, width, height);
	}
}
