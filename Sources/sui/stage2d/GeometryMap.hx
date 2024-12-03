package sui.stage2d;

import kha.Color;
import kha.Image;

abstract GeometryMap(Image) {
	public var image(get, set):Image;

	inline function get_image():Image {
		return this;
	}

	inline function set_image(value:Image):Image {
		this = value;
		return value;
	}

	inline function new(image:Image) {
		this = image;
	}

	public static inline function createBlank(mapWidth:Int, mapHeight:Int):GeometryMap {
		return new GeometryMap(Image.createRenderTarget(mapWidth * 4, mapHeight, null, SUI.options.samplesPerPixel));
	}

	public var g1(get, never):kha.graphics1.Graphics;
	public var g2(get, never):kha.graphics2.Graphics;
	public var g4(get, never):kha.graphics4.Graphics;

	inline function get_g1() {
		return this.g1;
	}

	inline function get_g2() {
		return this.g2;
	}

	inline function get_g4() {
		return this.g4;
	}

	public var width(get, never):Int;
	public var height(get, never):Int;

	inline function get_width():Int {
		return this.width;
	}

	inline function get_height():Int {
		return this.height;
	}

	public var mapWidth(get, set):Int;
	public var mapHeight(get, set):Int;

	inline function get_mapWidth():Int {
		return Std.int(this.width / 4);
	}

	inline function set_mapWidth(value:Int):Int {
		resize(value * 4, this.height);
		return value;
	}

	inline function get_mapHeight():Int {
		return Std.int(this.height / 4);
	}

	inline function set_mapHeight(value:Int):Int {
		resize(this.width, value);
		return value;
	}

	public inline function resize(mapWidth:Int, mapHeight:Int):Void {
		var img = GeometryMap.createBlank(mapWidth, mapHeight).image;
		img.g2.begin();
		img.g2.drawScaledImage(this, 0, 0, img.width, img.height);
		img.g2.end();
		this = img;
	}

	public var albedoMap(get, set):Image;
	public var emissionMap(get, set):Image;
	public var normalMap(get, set):Image;
	public var ormMap(get, set):Image;

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

	inline function getMapRect(mapOffset:Int):Array<Int> {
		return [this.width * mapOffset, 0, this.width * (mapOffset + 1), this.height];
	}

	inline function setMapColor(mapOffset:Int = 0, color:Color):Void {
		var mapRect = getMapRect(mapOffset);
		this.g2.begin(false);
		this.g2.color = color;
		this.g2.fillRect(mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		this.g2.end();
	}

	public inline function setAlbedoColor(value:Color):Void {
		setMapColor(0, value);
	}

	public inline function setEmissionColor(value:Color):Void {
		setMapColor(1, value);
	}

	public inline function setNormalColor(value:Color):Void {
		setMapColor(2, value);
	}

	public inline function setORMColor(value:Color):Void {
		setMapColor(3, value);
	}

	inline function setMap(mapOffset:Int = 0, map:Image):Void {
		var mapRect = getMapRect(mapOffset);
		this.g2.begin(false);
		this.g2.drawScaledImage(map, mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		this.g2.end();
	}

	inline function getMap(mapOffset:Int = 0):Image {
		var mapRect = getMapRect(mapOffset);
		var map = Image.createRenderTarget(this.width, this.height);
		map.g2.begin(false);
		map.g2.drawSubImage(this, 0, 0, mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		map.g2.end();
		return map;
	}
}
