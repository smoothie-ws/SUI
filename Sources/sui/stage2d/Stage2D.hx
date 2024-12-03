package sui.stage2d;

import kha.FastFloat;
import kha.Image;
import kha.Canvas;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.SUIShaders;
import sui.elements.DrawableElement;
import sui.stage2d.objects.Object;
import sui.stage2d.objects.MeshObject;
import sui.stage2d.lighting.Light;
import sui.stage2d.objects.Sprite;

class Stage2D extends DrawableElement {
	public var gbuffer:GBuffer = {};

	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	var meshes:Array<MeshObject> = [];
	var lights:Array<Light> = [];

	public function new() {
		super();
	}

	inline function setLeft(value:FastFloat) {
		var v = vertices.lock();
		var _x = (value / SUI.scene.backbuffer.width) * 2 - 1;
		v[0] = _x;
		v[6] = _x;
		vertices.unlock();
	}

	inline function setTop(value:FastFloat) {
		var v = vertices.lock();
		var _y = (value / SUI.scene.backbuffer.height) * 2 - 1;
		v[1] = _y;
		v[7] = _y;
		vertices.unlock();
	}

	inline function setRight(value:FastFloat) {
		var v = vertices.lock();
		var _x = (value / SUI.scene.backbuffer.width) * 2 - 1;
		v[2] = _x;
		v[4] = _x;
		vertices.unlock();
	}

	inline function setBottom(value:FastFloat) {
		var v = vertices.lock();
		var _y = (value / SUI.scene.backbuffer.height) * 2 - 1;
		v[3] = _y;
		v[5] = _y;
		vertices.unlock();
	}

	public inline function add(object:Object) {
		if (object is MeshObject) {
			var mesh:MeshObject = cast object;
			var added = false;
			for (i in 0...meshes.length)
				if (meshes[i].z > object.z) {
					meshes.insert(i, mesh);
					added = true;
					break;
				}
			if (!added)
				meshes.push(mesh);
		} else if (object is Light) {
			var light:Light = cast object;
			if (light.isCastingShadows)
				lights.push(light);
		}
	}

	override inline function resize(w:Int, h:Int) {
		width = w;
		height = h;
		gbuffer.createBuffers(w, h);
	}

	override public function construct() {
		vertices = new VertexBuffer(4, SUIShaders.deferredRenderer.structure, StaticUsage);
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

		gbuffer.createBuffers(Std.int(width), Std.int(height));
	}

	public inline function update() {};

	override inline function draw(target:Canvas) {
		target.g2.end();

		gbuffer.clear();
		gbuffer.drawMeshes(meshes);

		for (light in lights) {
			var vertData:Array<Float> = [];
			var indData:Array<Int> = [];
			var indOffset = 0;

			for (mesh in meshes) {
				if (!mesh.isCastingShadows)
					continue;

				var shadowTriangles = light.castShadows(mesh);
				for (vert in shadowTriangles.vertices)
					vertData.push(vert);
				for (ind in shadowTriangles.indices)
					indData.push(indOffset + ind);
				indOffset += Std.int(shadowTriangles.vertices.length / 3);
			}

			if (!(vertData.length == 0 || indData.length == 0))
				gbuffer.drawShadows(vertData, indData);

			SUIShaders.deferredRenderer.draw(target, vertices, indices, [
				gbuffer.ormd,
				gbuffer.albedo,
				gbuffer.normal,
				gbuffer.shadows,
				gbuffer.emission,
				light.x,
				light.y,
				light.z,
				light.color.R,
				light.color.G,
				light.color.B,
				light.strength,
				light.radius
			]);
		}

		for (mesh in meshes) {
			if (mesh.shaded)
				continue;

			if (mesh is Sprite) {
				var sprite:Sprite = cast mesh;
				target.g2.begin(false);
				SUIShaders.imageDrawer.draw(target, sprite.vertices, sprite.indices, [sprite.albedoMap]);
				target.g2.end();
			} else {
				target.g2.begin(false);
				SUIShaders.colorDrawer.draw(target, mesh.vertices, mesh.indices, [mesh.albedo]);
				target.g2.end();
			}
		}

		target.g2.begin(false);
	}
}

@:structInit
private class GBuffer {
	public var buffer:Image = null; // [albedo, normal, orm, emission, shadows]

	public inline function clear() {
		buffer.g4.clear();
	}

	public inline function createBuffers(w:Int, h:Int) {
		buffer = Image.createRenderTarget(w * 5, h, null, DepthOnly, SUI.options.samplesPerPixel);
	}

	public inline function drawMeshes(meshes:Array<MeshObject>) {
		var vertData:Array<Float> = [];
		var indData:Array<Int> = [];

		var indOffset = 0;
		for (mesh in meshes) {
			if (!mesh.isShaded)
				continue;
			var vertCount = mesh.vertices.length;
			for (i in 0...vertCount) {
				vertData.push(mesh.vertices[i].x);
				vertData.push(mesh.vertices[i].y);
				vertData.push(mesh.z);

				if (i < vertCount - 2) {
					indData.push(indOffset + 0);
					indData.push(indOffset + i + 1);
					indData.push(indOffset + i + 2);
				}
			}
			indOffset += vertCount;
		}

		buffer.g2.begin(false);
		DeferredRenderer.lighting.draw(buffer, mesh.vertices, mesh.indices, [sprite.albedoMap]);
		buffer.g2.end();
	}

	public inline function drawShadows(vertData:Array<Float>, indData:Array<Int>) {
		var vertices = new VertexBuffer(Std.int(vertData.length / 3), SUIShaders.shadowCaster.structure, StaticUsage);
		var vert = vertices.lock();
		for (i in 0...vertData.length)
			vert[i] = vertData[i];
		vertices.unlock();

		var indices = new IndexBuffer(indData.length, StaticUsage);
		var ind = indices.lock();
		for (i in 0...indData.length)
			ind[i] = indData[i];
		indices.unlock();

		shadows.g2.begin(true);
		SUIShaders.shadowCaster.draw(shadows, vertices, indices);
		shadows.g2.end();
	}
}
