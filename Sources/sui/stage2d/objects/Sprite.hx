package sui.stage2d.objects;

import kha.Color;
import kha.Image;

class Sprite extends MeshObject {
	public var albedoMap(get, set):Image;
	public var emissionMap(get, set):Image;
	public var normalMap(get, set):Image;
	public var ormMap(get, set):Image;

	override public inline function new(width:Int, height:Int) {
		super();
		resize(width, height);
	}

	override inline function set_width(value:Int):Int {
		width = value;
		var gmap = geometryMap;
		geometryMap = Image.create(width * 4, height);
		geometryMap.g2.begin();
		geometryMap.g2.drawScaledImage(gmap, 0, 0, width * 4, height);
		geometryMap.g2.end();

		return value;
	}

	override inline function set_height(value:Int):Int {
		height = value;
		var gmap = geometryMap;
		geometryMap = Image.create(width * 4, height);
		geometryMap.g2.begin();
		geometryMap.g2.drawScaledImage(gmap, 0, 0, width * 4, height);
		geometryMap.g2.end();

		return value;
	}

	public inline function resize(w:Int, h:Int) {
		width = w;
		height = h;
	}

	inline function getMapRect(mapOffset:Int):Array<Int> {
		return [width * mapOffset, 0, width * (mapOffset + 1), height];
	}

	inline function setMap(mapOffset:Int = 0, map:Image):Void {
		var mapRect = getMapRect(mapOffset);
		geometryMap.g2.begin();
		geometryMap.g2.drawScaledImage(map, mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		geometryMap.g2.end();
	}

	inline function getMap(mapOffset:Int = 0):Image {
		var mapRect = getMapRect(mapOffset);
		var map = Image.create(width, height);
		map.g2.begin();
		map.g2.drawSubImage(geometryMap, 0, 0, mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		map.g2.end();
		return map;
	}

	inline function get_albedoMap():Image {
		return getMap(0);
	}

	inline function set_albedoMap(value:Image):Image {
		setMap(0, value);
		return value;
	}

	inline function get_emissionMap():Image {
		return getMap(1);
	}

	inline function set_emissionMap(value:Image):Image {
		setMap(1, value);
		return value;
	}

	inline function get_normalMap():Image {
		return getMap(2);
	}

	inline function set_normalMap(value:Image):Image {
		setMap(2, value);
		return value;
	}

	inline function get_ormMap():Image {
		return getMap(3);
	}

	inline function set_ormMap(value:Image):Image {
		setMap(3, value);
		return value;
	}

	override inline function get_albedo():Color {
		return null;
	}

	override inline function set_albedo(value:Color):Color {
		return null;
	}

	override inline function get_emission():Color {
		return null;
	}

	override inline function set_emission(value:Color):Color {
		return null;
	}

	override inline function get_normal():Color {
		return null;
	}

	override inline function set_normal(value:Color):Color {
		return null;
	}

	override inline function get_orm():Color {
		return null;
	}

	override inline function set_orm(value:Color):Color {
		return null;
	}
}
