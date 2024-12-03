package sui.stage2d;

import kha.FastFloat;
import kha.Image;
import kha.Canvas;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.SUIShaders;
import sui.core.graphics.DeferredRenderer;
import sui.elements.DrawableElement;
import sui.stage2d.objects.Object;
import sui.stage2d.objects.MeshObject;
import sui.stage2d.objects.Sprite;
import sui.stage2d.objects.Light;

class Stage2D extends DrawableElement {
	public var gbuffer:Image = null; // [albedo, normal, orm, emission]

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

		gbuffer = Image.createRenderTarget(Std.int(width * 4), Std.int(height), null, SUI.options.samplesPerPixel);
	}

	override public function construct() {
		vertices = new VertexBuffer(4, DeferredRenderer.lighting.structure, StaticUsage);
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

		gbuffer = Image.createRenderTarget(Std.int(width * 4), Std.int(height), null, DepthOnly, SUI.options.samplesPerPixel);
	}

	public inline function update() {};

	override inline function draw(target:Canvas) {
		target.g2.end();

		gbuffer.g4.clear();
		drawMeshes();

		// for (light in lights) {
		// 	var vertData:Array<Float> = [];
		// 	var indData:Array<Int> = [];
		// 	var indOffset = 0;

		// 	for (mesh in meshes) {
		// 		if (!mesh.isCastingShadows)
		// 			continue;

		// 		var shadowTriangles = light.castShadows(mesh);
		// 		for (vert in shadowTriangles.vertices)
		// 			vertData.push(vert);
		// 		for (ind in shadowTriangles.indices)
		// 			indData.push(indOffset + ind);
		// 		indOffset += Std.int(shadowTriangles.vertices.length / 3);
		// 	}

		// 	if (!(vertData.length == 0 || indData.length == 0))
		// 		drawShadows(vertData, indData);

		// 	DeferredRenderer.draw(target, vertices, indices, [
		// 		gbuffer.ormd,
		// 		gbuffer.albedo,
		// 		gbuffer.normal,
		// 		gbuffer.shadows,
		// 		gbuffer.emission,
		// 		light.x,
		// 		light.y,
		// 		light.z,
		// 		light.color.R,
		// 		light.color.G,
		// 		light.color.B,
		// 		light.strength,
		// 		light.radius
		// 	]);
		// }

		target.g2.begin(false);
	}

	public inline function drawMeshes() {
		var meshCount = 0;
		var vertCount = 0;
		var vertData:Array<Float> = [];
		var indData:Array<Int> = [];

		var gMapsArray:Array<Image> = [];
		var maxW = 0;
		var maxH = 0;

		for (mesh in meshes) {
			if (!mesh.isShaded)
				continue;
			gMapsArray.push(mesh.geometryMap);
			maxW = mesh.width > maxW ? mesh.width : maxW;
			maxH = mesh.height > maxH ? mesh.height : maxH;

			var vCount = mesh.vertices.length;
			for (i in 0...vCount) {
				vertData.push(mesh.vertices[i].pos.x);
				vertData.push(mesh.vertices[i].pos.y);
				vertData.push(mesh.z);
				vertData.push(meshes.indexOf(mesh));
				vertData.push(mesh.vertices[i].uv.x);
				vertData.push(mesh.vertices[i].uv.y);

				if (i < vCount - 2) {
					indData.push(vertCount);
					indData.push(vertCount + i + 1);
					indData.push(vertCount + i + 2);
				}
			}
			vertCount += vCount;
			++meshCount;
		}

		var vertices = new VertexBuffer(vertCount, DeferredRenderer.geometry.structure, StaticUsage);
		var v = vertices.lock();
		for (i in 0...vertData.length)
			v[i] = vertData[i];
		vertices.unlock();

		var indices = new IndexBuffer(indData.length, StaticUsage);
		var ind = indices.lock();
		for (i in 0...indData.length)
			ind[i] = indData[i];
		indices.unlock();

		var gMaps = Image.create(maxW * 4, maxH * meshCount);
		gMaps.g2.begin();
		for (i in 0...gMapsArray.length)
			gMaps.g2.drawScaledImage(gMapsArray[i], 0, i * maxH, maxW, maxH);
		gMaps.g2.end();

		gbuffer.g2.begin(false);
		DeferredRenderer.geometry.draw(gbuffer, vertices, indices, [gMaps, meshCount]);
		gbuffer.g2.end();
	}
}
