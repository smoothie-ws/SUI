package sui.stage2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
// sui
import sui.stage2d.batches.MeshBatch;

@:structInit
@:allow(sui.stage2d.Stage2D)
@:allow(sui.stage2d.batches.MeshBatch)
class MeshObject extends Object {
	var batch:MeshBatch;
	var vertCount:Int = 0;
	var vertOffset:Int = 0;

	public var opacity:FastFloat = 1.0;
	public var isShaded:Bool = true;
	public var isCastingShadows:Bool = true;

	public inline function new(stage:Stage2D, vertCount:Int) {
		super(stage);

		this.vertCount = vertCount;
		albedoColor = Color.fromFloats(0.9, 0.9, 0.9);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.5, 0.0);
	}

	public inline function setVertices(vertices:Array<Float>) {
		if (vertices.length != vertCount * 5)
			return;
		var vert = batch.vertices.lock(vertOffset * 5, (vertOffset + vertCount) * 5);
		for (i in 0...vertices.length)
			vert[i] = vertices[i];
		batch.vertices.unlock();
	}

	public var albedoMap(never, set):Image;
	public var emissionMap(never, set):Image;
	public var normalMap(never, set):Image;
	public var ormMap(never, set):Image;

	inline function set_albedoMap(value:Image):Image {
		batch.gbuffer.setMapInstance(batch.gbuffer.albedo, value, instanceID);
		return value;
	}

	inline function set_emissionMap(value:Image):Image {
		batch.gbuffer.setMapInstance(batch.gbuffer.emission, value, instanceID);
		return value;
	}

	inline function set_normalMap(value:Image):Image {
		batch.gbuffer.setMapInstance(batch.gbuffer.normal, value, instanceID);
		return value;
	}

	inline function set_ormMap(value:Image):Image {
		batch.gbuffer.setMapInstance(batch.gbuffer.orm, value, instanceID);
		return value;
	}

	public var albedoColor(never, set):Color;
	public var emissionColor(never, set):Color;
	public var normalColor(never, set):Color;
	public var ormColor(never, set):Color;

	function set_albedoColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(batch.gbuffer.albedo, value, instanceID);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(batch.gbuffer.emission, value, instanceID);
		return value;
	}

	function set_normalColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(batch.gbuffer.normal, value, instanceID);
		return value;
	}

	function set_ormColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(batch.gbuffer.orm, value, instanceID);
		return value;
	}
}
