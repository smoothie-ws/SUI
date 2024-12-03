package sui.stage2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;

typedef Vertex = {
	var pos:FastVector2;
	var uv:FastVector2;
}

@:structInit
@:allow(sui.stage2d.Stage2D)
class MeshObject extends Object {
	public var vertices:Array<Vertex> = [];
	public var opacity:FastFloat = 1.0;
	public var isShaded:Bool = true;
	public var isCastingShadows:Bool = true;

	var geometryMap:Image = Image.createRenderTarget(4, 1); // [albedo, normal, orm, emission]

	@:isVar public var width(default, set):Int = 1;
	@:isVar public var height(default, set):Int = 1;

	function set_width(value:Int):Int {
		return value;
	}

	function set_height(value:Int):Int {
		return value;
	}

	public var albedo(get, set):Color;
	public var emission(get, set):Color;
	public var normal(get, set):Color;
	public var orm(get, set):Color;

	public inline function new() {
		super();
		albedo = Color.fromFloats(0.85, 0.85, 0.85);
		emission = Color.fromFloats(0.0, 0.0, 0.0);
		normal = Color.fromFloats(0.5, 0.5, 1.0);
		orm = Color.fromFloats(0.85, 0.85, 0.85);
	}

	function get_albedo():Color {
		return geometryMap.at(0, 0);
	}

	function set_albedo(value:Color):Color {
		geometryMap.g1.begin();
		geometryMap.g1.setPixel(0, 0, value);
		geometryMap.g1.end();
		return value;
	}

	function get_emission():Color {
		return geometryMap.at(1, 0);
	}

	function set_emission(value:Color):Color {
		geometryMap.g1.begin();
		geometryMap.g1.setPixel(1, 0, value);
		geometryMap.g1.end();
		return value;
	}

	function get_normal():Color {
		return geometryMap.at(2, 0);
	}

	function set_normal(value:Color):Color {
		geometryMap.g1.begin();
		geometryMap.g1.setPixel(2, 0, value);
		geometryMap.g1.end();
		return value;
	}

	function get_orm():Color {
		return geometryMap.at(3, 0);
	}

	function set_orm(value:Color):Color {
		geometryMap.g1.begin();
		geometryMap.g1.setPixel(3, 0, value);
		geometryMap.g1.end();
		return value;
	}
}
