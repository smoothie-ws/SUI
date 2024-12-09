package sui.stage2d.objects;

import sui.core.graphics.DeferredRenderer;
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
	@readonly var batch:SpriteBatch;

	var vertOffset:Int = 0;

	override inline function get_instanceID():Int {
		return Std.int(batch.vertData[vertOffset + 2]);
	}

	override inline function set_instanceID(value:Int):Int {
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			batch.vertData[offset + 2] = value;
		}
		if (value >= batch.gbuffer.packsCount)
			batch.gbuffer.extend();
		trace(value, batch.gbuffer.packsCount);

		return value;
	}

	public var isShaded:Bool = true;
	public var blendMode(get, set):BlendMode;
	public var shadowOpacity:FastFloat = 1.0;
	public var isCastingShadows:Bool = true;

	public inline function get_blendMode():BlendMode {
		return batch.blendModeArr[instanceID];
	}

	public inline function set_blendMode(value:BlendMode):BlendMode {
		batch.blendModeArr[instanceID] = value;
		return value;
	}

	public inline function new(stage:Stage2D) {
		super(stage);

		albedoColor = Color.fromFloats(0.9, 0.9, 0.9);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.5, 0.0);
	}

	public var centerPoint(get, never):FastVector2;

	inline function get_centerPoint():FastVector2 {
		var c:FastVector2 = {};

		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			c.x += batch.vertData[offset + 0];
			c.y += batch.vertData[offset + 1];
		}
		c.x /= 4;
		c.y /= 4;
		return c;
	}

	override inline function scale(x:FastFloat, y:FastFloat) {
		var c = centerPoint;
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			batch.vertData[offset + 0] = (batch.vertData[offset + 0] - c.x) * x + c.x;
			batch.vertData[offset + 1] = (batch.vertData[offset + 1] - c.y) * y + c.y;
		}
	}

	override inline function translate(x:FastFloat, y:FastFloat) {
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			batch.vertData[offset + 0] += x;
			batch.vertData[offset + 1] += y;
		}
	}

	public var vertices(get, set):Array<FastVector2>;

	public inline function getVertex(i:Int):FastVector2 {
		var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
		return {
			x: batch.vertData[offset + 0],
			y: batch.vertData[offset + 1],
		}
	}

	public inline function setVertex(i:Int, vertex:FastVector2) {
		var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
		batch.vertData[offset + 0] = vertex.x;
		batch.vertData[offset + 1] = vertex.y;
	}

	public inline function get_vertices():Array<FastVector2> {
		var vertices = [];
		for (i in 0...4)
			vertices.push(getVertex(i));
		return vertices;
	}

	public inline function set_vertices(vertices:Array<FastVector2>):Array<FastVector2> {
		if (vertices.length == 4)
			for (i in 0...4)
				setVertex(i, vertices[i]);
		return vertices;
	}

	override inline function set_z(value:FastFloat):FastFloat {
		batch.zArr[instanceID] = z;
		for (c in children)
			c.z += value - z;
		z = value;
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
		batch.gbuffer.setMapInstance(0, instanceID, value);
		return value;
	}

	inline function get_emissionMap() {
		return batch.gbuffer.getMapInstance(1, instanceID);
	}

	inline function set_emissionMap(value:Image):Image {
		batch.gbuffer.setMapInstance(1, instanceID, value);
		return value;
	}

	inline function get_normalMap() {
		return batch.gbuffer.getMapInstance(2, instanceID);
	}

	inline function set_normalMap(value:Image):Image {
		batch.gbuffer.setMapInstance(2, instanceID, value);
		return value;
	}

	inline function get_ormMap() {
		return batch.gbuffer.getMapInstance(3, instanceID);
	}

	inline function set_ormMap(value:Image):Image {
		batch.gbuffer.setMapInstance(3, instanceID, value);
		return value;
	}

	public var albedoColor(never, set):Color;
	public var emissionColor(never, set):Color;
	public var normalColor(never, set):Color;
	public var ormColor(never, set):Color;

	function set_albedoColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(0, instanceID, value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(1, instanceID, value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(2, instanceID, value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		batch.gbuffer.setMapInstanceColor(3, instanceID, value);
		return value;
	}
}
