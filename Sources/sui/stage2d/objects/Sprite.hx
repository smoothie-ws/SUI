package sui.stage2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
// sui
import sui.stage2d.graphics.BlendMode;
import sui.stage2d.batches.SpriteBatch;

@:structInit
@:allow(sui.stage2d.Stage2D)
@:allow(sui.stage2d.batches.SpriteBatch)
class Sprite extends Object {
	var batch:SpriteBatch;

	public var isShaded:Bool = true;
	public var blendMode(get, set):BlendMode;
	public var shadowOpacity:FastFloat = 1.0;
	public var isCastingShadows:Bool = true;

	public inline function get_blendMode():BlendMode {
		return batch.blendModes[instanceID];
	}

	public inline function set_blendMode(value:BlendMode):BlendMode {
		batch.blendModes[instanceID] = value;
		return value;
	}

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

		for (i in 0...vertices.length) {
			batch.vertData[instanceID * 24 + i * 6 + 0] = vertices[i].x;
			batch.vertData[instanceID * 24 + i * 6 + 1] = vertices[i].y;
		}
	}

	override inline function set_z(value:FastFloat):FastFloat {
		for (c in children)
			c.z += value - z;
		z = value;

		for (i in 0...4)
			batch.vertData[instanceID * 24 + i * 6 + 2] = z;
		return value;
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
