package sui.stage2d;

import kha.Image;
import kha.Canvas;
import kha.FastFloat;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.core.graphics.DeferredRenderer;
import sui.elements.DrawableElement;
import sui.stage2d.objects.Object;
import sui.stage2d.objects.MeshObject;
import sui.stage2d.objects.Light;

class Stage2D extends DrawableElement {
	public var gbuffer:GeometryMap = new GeometryMap(1, 1);

	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	var objects:Array<Object> = [];

	public function new() {
		super();

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
	}

	inline function setLeft(value:FastFloat) {
		var v = vertices.lock();
		var _x = (value / SUI.scene.backbuffer.width) * 2 - 1;
		v[0] = _x;
		v[6] = _x;
		vertices.unlock();

		if (width != 0 && height != 0)
			gbuffer.resize(Std.int(width), Std.int(height));
	}

	inline function setTop(value:FastFloat) {
		var v = vertices.lock();
		var _y = (value / SUI.scene.backbuffer.height) * 2 - 1;
		v[1] = _y;
		v[7] = _y;
		vertices.unlock();

		if (width != 0 && height != 0)
			gbuffer.resize(Std.int(width), Std.int(height));
	}

	inline function setRight(value:FastFloat) {
		var v = vertices.lock();
		var _x = (value / SUI.scene.backbuffer.width) * 2 - 1;
		v[2] = _x;
		v[4] = _x;
		vertices.unlock();

		if (width != 0 && height != 0)
			gbuffer.resize(Std.int(width), Std.int(height));
	}

	inline function setBottom(value:FastFloat) {
		var v = vertices.lock();
		var _y = (value / SUI.scene.backbuffer.height) * 2 - 1;
		v[3] = _y;
		v[5] = _y;
		vertices.unlock();

		if (width != 0 && height != 0)
			gbuffer.resize(Std.int(width), Std.int(height));
	}

	public inline function add(object:Object) {
		objects.push(object);
	}

	override inline function draw(target:Canvas) {
		target.g2.end();

		var meshes:Array<MeshObject> = [];
		var lights:Array<Light> = [];

		for (object in objects) {
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
				lights.push(light);
			}
		}

		drawMeshes(meshes);

		var shadowMap = Image.createRenderTarget(Std.int(width), Std.int(height));

		for (light in lights) {
			light.drawShadows(shadowMap, meshes);

			target.g2.begin(false);
			DeferredRenderer.lighting.draw(target, vertices, indices, [
				gbuffer.albedoMap,
				gbuffer.emissionMap,
				gbuffer.normalMap,
				gbuffer.ormMap,
				shadowMap,
				light.x,
				light.y,
				light.z,
				light.color.R,
				light.color.G,
				light.color.B,
				light.power,
				light.radius
			]);
			target.g2.end();
		}

		target.g2.begin(false);
	}

	inline function drawMeshes(meshes:Array<MeshObject>) {
		var meshCount = 0;
		var vertCount = 0;
		var vertData:Array<Float> = [];
		var indData:Array<Int> = [];

		var gMapsArray:Array<GeometryMap> = [];
		var maxW = 0;
		var maxH = 0;

		for (mesh in meshes) {
			if (!mesh.isShaded)
				continue;

			gMapsArray.push(mesh.geometryMap);
			var w = mesh.geometryMap.albedoMap.width;
			var h = mesh.geometryMap.albedoMap.height;

			maxW = w > maxW ? w : maxW;
			maxH = h > maxH ? h : maxH;

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

		if (maxW * maxH <= 0)
			return;

		var gMaps = new GeometryMap(maxW, maxH * meshCount);

		for (i in 0...4) {
			var map = gMaps.get(i);
			map.g2.begin();
			for (j in 0...gMapsArray.length)
				map.g2.drawScaledImage(gMapsArray[j].get(i), 0, j * maxH, maxW, maxH);
			map.g2.end();
		}

		if (gMaps == null)
			return;

		gbuffer.albedoMap.g4.begin([gbuffer.emissionMap, gbuffer.normalMap, gbuffer.ormMap]);
		DeferredRenderer.geometry.draw(gbuffer.albedoMap, vertices, indices, [gMaps.albedoMap, gMaps.emissionMap, gMaps.normalMap, gMaps.ormMap, meshCount]);
		gbuffer.albedoMap.g4.end();
	}
}
