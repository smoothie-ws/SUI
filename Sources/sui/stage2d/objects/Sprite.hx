package sui.stage2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
// sui
import sui.core.graphics.DeferredRenderer;
import sui.stage2d.graphics.BlendMode;
import sui.stage2d.batches.SpriteBatch;
import sui.stage2d.graphics.MapPack;

@:structInit
@:allow(sui.stage2d.Stage2D, sui.stage2d.batches.SpriteBatch)
class Sprite extends Object {
	public var albedoMap(get, set):Image;
	public var emissionMap(get, set):Image;
	public var normalMap(get, set):Image;
	public var ormMap(get, set):Image;
	@:isVar public var albedoColor(default, set):Color;
	@:isVar public var emissionColor(default, set):Color;
	@:isVar public var normalColor(default, set):Color;
	@:isVar public var ormColor(default, set):Color;

	@:isVar public var blendMode(default, set):BlendMode;

	public var shadowVerts:Array<FastVector2> = [];
	public var shadowOpacity:FastFloat = 1.0;
	public var shadowCasting:Bool = true;

	public var vertices(get, set):Array<FastVector2>;
	public var centerPoint(get, never):FastVector2;

	inline function get_centerPoint():FastVector2 {
		var c:FastVector2 = {};

		for (vert in vertices) {
			c.x += vert.x;
			c.y += vert.y;
		}
		c.x /= vertices.length;
		c.y /= vertices.length;
		return c;
	}

	#if SUI_STAGE2D_BATCHING
	@readonly var batch:SpriteBatch;
	var vertOffset:Int = 0;

	public var instanceID(get, set):Int;

	public inline function new(stage:Stage2D) {
		super(stage);
	}

	inline function get_instanceID():Int {
		var vertData = batch.vertices.lock();
		var _id = Std.int(vertData[vertOffset + 2]);
		batch.vertices.unlock();
		return _id;
	}

	inline function set_instanceID(value:Int):Int {
		var vertData = batch.vertices.lock();
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			vertData[offset + 2] = value;
		}
		if (value >= batch.gbuffer.packsCount)
			batch.gbuffer.extend();
		batch.vertices.unlock();

		return value;
	}

	public inline function get_vertices():Array<FastVector2> {
		var v = new Array<FastVector2>();
		var vertData = batch.vertices.lock();
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			v.push({
				x: vertData[offset + 0],
				y: vertData[offset + 1],
			});
		}
		batch.vertices.unlock();
		return v;
	}

	public inline function set_vertices(v:Array<FastVector2>):Array<FastVector2> {
		var vertData = batch.vertices.lock();
		if (v.length == 4)
			for (i in 0...4) {
				var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
				vertData[offset + 0] = v[i].x;
				vertData[offset + 1] = v[i].y;
			}
		batch.vertices.unlock();
		return v;
	}

	public inline function set_blendMode(value:BlendMode):BlendMode {
		blendMode = value;
		batch.blendModeArr[instanceID] = blendMode;
		return value;
	}

	override inline function scale(x:FastFloat, y:FastFloat) {
		var c = centerPoint;
		var vertData = batch.vertices.lock();
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] = (vertData[offset + 0] - c.x) * x + c.x;
			vertData[offset + 1] = (vertData[offset + 1] - c.y) * y + c.y;
		}
		batch.vertices.unlock();
	}

	override inline function translate(x:FastFloat, y:FastFloat) {
		var vertData = batch.vertices.lock();
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] += x;
			vertData[offset + 1] += y;
		}
		batch.vertices.unlock();
	}

	override inline function set_z(value:FastFloat):FastFloat {
		var vertData = batch.vertices.lock();
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			vertData[offset + 2] = value;
		}
		batch.vertices.unlock();

		for (c in children)
			c.z += value - z;
		z = value;
		return value;
	}

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

	function set_albedoColor(value:Color):Color {
		albedoColor = value;
		batch.gbuffer.setMapInstanceColor(0, instanceID, value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		emissionColor = value;
		batch.gbuffer.setMapInstanceColor(1, instanceID, value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		normalColor = value;
		batch.gbuffer.setMapInstanceColor(2, instanceID, value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		ormColor = value;
		batch.gbuffer.setMapInstanceColor(3, instanceID, value);
		return value;
	}
	#else
	public var gbuffer:MapPack;

	var vertBuffer:VertexBuffer;
	var indBuffer:IndexBuffer;

	public inline function new(stage:Stage2D) {
		super(stage);

		vertBuffer = new VertexBuffer(4, DeferredRenderer.geometry.structure, StaticUsage);

		var vertData = vertBuffer.lock();
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;

			vertData[offset + 0] = 0; // X
			vertData[offset + 1] = 0; // Y
			vertData[offset + 2] = 0; // Z
			vertData[offset + 3] = i == 2 || i == 3 ? 1 : 0; // U
			vertData[offset + 4] = i == 1 || i == 2 ? 1 : 0; // V
		}
		vertBuffer.unlock();

		indBuffer = new IndexBuffer(6, StaticUsage);
		var ind = indBuffer.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 3;
		ind[4] = 2;
		ind[5] = 0;
		indBuffer.unlock();

		gbuffer = new MapPack(512, 512, 4);
	}

	public inline function get_vertices():Array<FastVector2> {
		var v = new Array<FastVector2>();
		var vertData = vertBuffer.lock();
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			v.push({
				x: vertData[offset + 0],
				y: vertData[offset + 1],
			});
		}
		vertBuffer.unlock();
		return v;
	}

	public inline function set_vertices(v:Array<FastVector2>):Array<FastVector2> {
		var vertData = vertBuffer.lock();
		if (v.length == 4)
			for (i in 0...4) {
				var offset = i * DeferredRenderer.geometry.structSize;
				vertData[offset + 0] = v[i].x;
				vertData[offset + 1] = v[i].y;
			}
		vertBuffer.unlock();
		return v;
	}

	override inline function scale(x:FastFloat, y:FastFloat) {
		var vertData = vertBuffer.lock();
		var c = centerPoint;
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] = (vertData[offset + 0] - c.x) * x + c.x;
			vertData[offset + 1] = (vertData[offset + 1] - c.y) * y + c.y;
		}
		vertBuffer.unlock();
	}

	override inline function translate(x:FastFloat, y:FastFloat) {
		var vertData = vertBuffer.lock();
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] += x;
			vertData[offset + 1] += y;
		}
		vertBuffer.unlock();
	}

	public inline function set_blendMode(value:BlendMode):BlendMode {
		blendMode = value;
		return value;
	}

	inline function get_albedoMap() {
		return gbuffer[0];
	}

	inline function set_albedoMap(value:Image):Image {
		gbuffer.setMap(0, value);
		return value;
	}

	inline function get_emissionMap() {
		return gbuffer[1];
	}

	inline function set_emissionMap(value:Image):Image {
		gbuffer.setMap(1, value);
		return value;
	}

	inline function get_normalMap() {
		return gbuffer[2];
	}

	inline function set_normalMap(value:Image):Image {
		gbuffer.setMap(2, value);
		return value;
	}

	inline function get_ormMap() {
		return gbuffer[3];
	}

	inline function set_ormMap(value:Image):Image {
		gbuffer.setMap(3, value);
		return value;
	}

	function set_albedoColor(value:Color):Color {
		albedoColor = value;
		gbuffer.setMapColor(0, value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		emissionColor = value;
		gbuffer.setMapColor(1, value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		normalColor = value;
		gbuffer.setMapColor(2, value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		ormColor = value;
		gbuffer.setMapColor(3, value);
		return value;
	}

	#if SUI_STAGE2D_SHADING_DEFERRED
	public inline function drawGeometry(target:Canvas) {
		DeferredRenderer.geometry.draw(target, vertBuffer, indBuffer, [gbuffer[0], gbuffer[1], gbuffer[2], gbuffer[3], blendMode]);
	}
	#end
	#end
}
