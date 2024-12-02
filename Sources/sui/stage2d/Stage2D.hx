package sui.stage2d;

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

class Stage2D extends DrawableElement {
	var gbuffer:GBuffer;
	var backbuffer:Image;

	public var objects:Array<Object> = [];

	public function new() {
		super();
		gbuffer = new GBuffer(Std.int(width), Std.int(height));
	}

	override inline function resize(width:Int, heigth:Int) {
		this.width = width;
		this.height = height;
		gbuffer.resize(width, heigth);
	}

	override inline function draw(target:Canvas) {
		var meshes:Array<MeshObject> = [];
		var lights:Array<Light> = [];

		for (object in objects) {
			if (object is MeshObject) {
				var mesh:MeshObject = cast object;
				if (mesh.isCastingShadows)
					meshes.push(mesh);
			} else if (object is Light) {
				var light:Light = cast object;
				if (light.isCastingShadows)
					lights.push(light);
			}
		}

		for (light in lights) {
			var vertData:Array<Float> = [];
			var indData:Array<Int> = [];
			var indOffset = 0;
			for (mesh in meshes) {
				var shadowTriangles = light.castShadows(mesh);
				for (vert in shadowTriangles.vertices)
					vertData.push(vert);
				for (ind in shadowTriangles.indices)
					indData.push(indOffset + ind);
				indOffset += Std.int(shadowTriangles.vertices.length / 3);
			}
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

			SUIShaders.shadowCaster.draw(gbuffer.shadowMap, vertices, indices);
		}
	}
}

private class GBuffer {
	public var shadowMap:Image;
	public var albedo:Image;
	public var emission:Image;
	public var normal:Image;
	public var ormd:Image; // [occlusion, metalness, roughness, depth]

	public inline function new(width:Int, heigth:Int) {
		resize(width, heigth);
	}

	public inline function resize(width:Int, heigth:Int) {
		albedo = Image.createRenderTarget(width, heigth);
		emission = Image.createRenderTarget(width, heigth);
		normal = Image.createRenderTarget(width, heigth);
		ormd = Image.createRenderTarget(width, heigth);
	}
}
