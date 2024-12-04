package sui.stage2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;

@:structInit
class Vertex {
	public var pos:FastVector2 = {};
	public var uv:FastVector2 = {};
}

@:structInit
@:allow(sui.stage2d.Stage2D)
class MeshObject extends Object {
	public var vertices:Array<Vertex> = [
		{pos: {x: -0.5, y: -0.5}, uv: {x: 0, y: 0}},
		{pos: {x: -0.5, y: 0.5}, uv: {x: 0, y: 1}},
		{pos: {x: 0.5, y: 0.5}, uv: {x: 1, y: 1}},
		{pos: {x: 0.5, y: -0.5}, uv: {x: 1, y: 0}}
	];
	public var opacity:FastFloat = 1.0;
	public var isShaded:Bool = true;
	public var isCastingShadows:Bool = true;

	public var geometryMap:GeometryMap;

	public inline function new() {
		super();
		geometryMap = new GeometryMap(1, 1);
		albedoColor = Color.fromFloats(0.9, 0.9, 0.9);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.0, 0.25);
	}

	@:isVar public var albedoColor(default, set):Color;
	@:isVar public var emissionColor(default, set):Color;
	@:isVar public var normalColor(default, set):Color;
	@:isVar public var ormColor(default, set):Color;

	function set_albedoColor(value:Color):Color {
		geometryMap.setAlbedoColor(value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		geometryMap.setEmissionColor(value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		geometryMap.setNormalColor(value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		geometryMap.setORMColor(value);
		return value;
	}

	public var albedoMap(get, set):Image;
	public var emissionMap(get, set):Image;
	public var normalMap(get, set):Image;
	public var ormMap(get, set):Image;

	inline function get_albedoMap():Image {
		return geometryMap.albedoMap;
	}

	inline function set_albedoMap(value:Image):Image {
		geometryMap.albedoMap = value;
		return value;
	}

	inline function get_emissionMap():Image {
		return geometryMap.emissionMap;
	}

	inline function set_emissionMap(value:Image):Image {
		geometryMap.emissionMap = value;
		return value;
	}

	inline function get_normalMap():Image {
		return geometryMap.normalMap;
	}

	inline function set_normalMap(value:Image):Image {
		geometryMap.normalMap = value;
		return value;
	}

	inline function get_ormMap():Image {
		return geometryMap.ormMap;
	}

	inline function set_ormMap(value:Image):Image {
		geometryMap.ormMap = value;
		return value;
	}
}
