package sui.stage2d.objects;

import kha.math.FastVector2;
import kha.Image;
import kha.Color;
import kha.FastFloat;
// sui
import sui.stage2d.batches.SpriteBatch;

@:structInit
@:allow(sui.stage2d.Stage2D)
@:allow(sui.stage2d.batches.SpriteBatch)
class Sprite extends Object {
	public var batch:SpriteBatch;

	public var opacity:FastFloat = 1.0;
	public var isShaded:Bool = true;
	public var isCastingShadows:Bool = true;

	public inline function new(stage:Stage2D) {
		super(stage);

		albedoColor = Color.fromFloats(0.9, 0.9, 0.9);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.5, 0.0);
	}

	public inline function setVertices(vertices:Array<FastVector2>) {
		if (vertices.length != 4)
			return;

		var vert = batch.vertices.lock();
		for (i in 0...vertices.length) {
			vert[instanceID * 24 + i * 6 + 0] = vertices[i].x;
			vert[instanceID * 24 + i * 6 + 1] = vertices[i].y;
		}
		batch.vertices.unlock();
	}

	public var albedoMap(get, set):Image;
	public var emissionMap(get, set):Image;
	public var normalMap(get, set):Image;
	public var ormMap(get, set):Image;

	inline function get_albedoMap() {
		return batch.gbuffer.getMapInstance(0, instanceID);
	}

	inline function set_albedoMap(value:Image):Image {
		batch.gbuffer.setMapInstance(0, value, instanceID);
		return value;
	}

	inline function get_emissionMap() {
		return batch.gbuffer.getMapInstance(1, instanceID);
	}

	inline function set_emissionMap(value:Image):Image {
		batch.gbuffer.setMapInstance(1, value, instanceID);
		return value;
	}

	inline function get_normalMap() {
		return batch.gbuffer.getMapInstance(2, instanceID);
	}

	inline function set_normalMap(value:Image):Image {
		batch.gbuffer.setMapInstance(2, value, instanceID);
		return value;
	}

	inline function get_ormMap() {
		return batch.gbuffer.getMapInstance(3, instanceID);
	}

	inline function set_ormMap(value:Image):Image {
		batch.gbuffer.setMapInstance(3, value, instanceID);
		return value;
	}

	public var albedoColor(never, set):Color;
	public var emissionColor(never, set):Color;
	public var normalColor(never, set):Color;
	public var ormColor(never, set):Color;

	function set_albedoColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(0, value, instanceID);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(1, value, instanceID);
		return value;
	}

	function set_normalColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(2, value, instanceID);
		return value;
	}

	function set_ormColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(3, value, instanceID);
		return value;
	}
}
