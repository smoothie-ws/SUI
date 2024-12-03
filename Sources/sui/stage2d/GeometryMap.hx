package sui.stage2d;

import kha.Color;
import kha.Image;

class GeometryMap {
	public var albedoMap:Image = null;
	public var emissionMap:Image = null;
	public var normalMap:Image = null;
	public var ormMap:Image = null;

	public inline function new(width:Int, height:Int) {
		resize(width, height);
	}

	public var composite(get, never):Image;

	inline function get_composite():Image {
		var img = Image.createRenderTarget(width * 4, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		img.g2.begin();
		img.g2.drawImage(albedoMap, 0, 0);
		img.g2.drawImage(emissionMap, width, 0);
		img.g2.drawImage(normalMap, width * 2, 0);
		img.g2.drawImage(ormMap, width * 3, 0);
		img.g2.end();
		return img;
	}

	@:isVar public var width(default, set):Int = 1;
	@:isVar public var height(default, set):Int = 1;

	inline function set_width(value:Int):Int {
		width = value;
		resize(width, height);
		return value;
	}

	inline function set_height(value:Int):Int {
		height = value;
		resize(width, height);
		return value;
	}

	inline function resizeMap(map:Image, mapWidth:Int, mapHeight:Int) {
		var img = Image.createRenderTarget(mapWidth, mapHeight, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		img.g2.begin();
		img.g2.drawScaledImage(map, 0, 0, img.width, img.height);
		img.g2.end();

		map = img;
	}

	public inline function resize(mapWidth:Int, mapHeight:Int):Void {
		resizeMap(albedoMap, mapWidth, mapHeight);
		resizeMap(emissionMap, mapWidth, mapHeight);
		resizeMap(normalMap, mapWidth, mapHeight);
		resizeMap(ormMap, mapWidth, mapHeight);
	}

	inline function setMapColor(map:Image, color:Color):Void {
		map.g2.begin(false);
		map.g2.color = color;
		map.g2.fillRect(0, 0, map.width, map.height);
		map.g2.end();
	}

	public inline function setAlbedoColor(value:Color):Void {
		setMapColor(albedoMap, value);
	}

	public inline function setEmissionColor(value:Color):Void {
		setMapColor(emissionMap, value);
	}

	public inline function setNormalColor(value:Color):Void {
		setMapColor(normalMap, value);
	}

	public inline function setORMColor(value:Color):Void {
		setMapColor(ormMap, value);
	}
}
