package sui.stage2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
#if (!SUI_STAGE2D_BATCHING)
import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
#end
// sui
import sui.core.graphics.DeferredRenderer;
import sui.stage2d.graphics.BlendMode;
#if SUI_STAGE2D_BATCHING
import sui.stage2d.batches.SpriteBatch;
#else
import sui.stage2d.graphics.MapPack;
#end

@:structInit
@:allow(sui.stage2d.Stage2D, sui.stage2d.batches.SpriteBatch)
class Sprite extends Object {
	public var blendMode(get, set):BlendMode;
	public var albedoMap(get, set):Image;
	public var emissionMap(get, set):Image;
	public var normalMap(get, set):Image;
	public var ormMap(get, set):Image;
	public var albedoColor(never, set):Color;
	public var emissionColor(never, set):Color;
	public var normalColor(never, set):Color;
	public var ormColor(never, set):Color;
	
	public var shadowVerts:Array<FastVector2> = [];
	public var shadowOpacity:FastFloat = 1.0;
	public var shadowCasting:Bool = true;

	public var vertices(get, set):Array<FastVector2>;
	public var centerPoint(get, never):FastVector2;

	public inline function get_vertices():Array<FastVector2> {
		var v = [];
		for (i in 0...4)
			v.push(getVertex(i));
		return v;
	}

	public inline function set_vertices(v:Array<FastVector2>):Array<FastVector2> {
		if (v.length == 4)
			for (i in 0...4)
				setVertex(i, v[i]);
		return v;
	}

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
	public inline function new(stage:Stage2D) {
		super(stage);

		albedoColor = Color.fromFloats(0.9, 0.9, 0.9);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.5, 0.0);
	}

	@readonly var batch:SpriteBatch;
	var vertOffset:Int = 0;

	public var instanceID(get, set):Int;

	inline function get_instanceID():Int {
		return Std.int(batch.vertData[vertOffset + 2]);
	}

	inline function set_instanceID(value:Int):Int {
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;
			batch.vertData[offset + 2] = value;
		}
		if (value >= batch.gbuffer.packsCount)
			batch.gbuffer.extend();

		return value;
	}

	public inline function get_blendMode():BlendMode {
		return batch.blendModeArr[instanceID];
	}

	public inline function set_blendMode(value:BlendMode):BlendMode {
		batch.blendModeArr[instanceID] = value;
		return value;
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

	override inline function set_z(value:FastFloat):FastFloat {
		batch.zArr[instanceID] = z;
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
	#else
	var gbuffer:MapPack;
	var vertBuffer:VertexBuffer;
	var indBuffer:IndexBuffer;

	@readonly public var vertData:Float32Array;

	public inline function new(stage:Stage2D) {
		super(stage);
		vertBuffer = new VertexBuffer(4, DeferredRenderer.geometry.structure, StaticUsage);
		indBuffer = new IndexBuffer(6, StaticUsage);
		var ind = indBuffer.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 3;
		ind[4] = 2;
		ind[5] = 0;
		indBuffer.unlock();

		gbuffer = new MapPack(512, 512, 4, RGBA32, DepthOnly, SUI.options.samplesPerPixel);

		albedoColor = Color.fromFloats(0.9, 0.9, 0.9);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.5, 0.0);

		lock();
	}

	inline function lock() {
		vertData = vertBuffer.lock();
	}

	inline function unlock() {
		vertBuffer.unlock();
	}

	public inline function getVertex(i:Int):FastVector2 {
		var offset = i * DeferredRenderer.geometry.structSize;
		return {
			x: vertData[offset + 0],
			y: vertData[offset + 1],
		}
	}

	public inline function setVertex(i:Int, vertex:FastVector2) {
		var offset = i * DeferredRenderer.geometry.structSize;
		vertData[offset + 0] = vertex.x;
		vertData[offset + 1] = vertex.y;
	}

	override inline function scale(x:FastFloat, y:FastFloat) {
		var c = centerPoint;
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] = (vertData[offset + 0] - c.x) * x + c.x;
			vertData[offset + 1] = (vertData[offset + 1] - c.y) * y + c.y;
		}
	}

	override inline function translate(x:FastFloat, y:FastFloat) {
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] += x;
			vertData[offset + 1] += y;
		}
	}

	function set_albedoColor(value:Color):Color {
		setMapColor(albedoMap, value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		setMapColor(emissionMap, value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		setMapColor(normalMap, value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		setMapColor(ormMap, value);
		return value;
	}

	inline function setMapColor(map:Image, color:Color) {
		map.g2.begin(true, Color.Transparent);
		map.g2.color = color;
		map.g2.fillRect(0, 0, map.width, map.height);
		map.g2.color = Color.White;
		map.g2.end();
	}

	#if SUI_STAGE2D_SHADING_DEFERRED
	public inline function drawGeometry(target:Canvas) {
		unlock();
		DeferredRenderer.geometry.draw(target, vertBuffer, indBuffer, [albedoMap, emissionMap, normalMap, ormMap, z, blendMode]);
		lock();
	}
	#end
	#end
}
