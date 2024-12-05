package sui.stage2d;

import kha.Color;
import kha.Image;

class GeometryMap {
	@readonly public var albedoMap:Image;
	@readonly public var emissionMap:Image;
	@readonly public var normalMap:Image;
	@readonly public var ormMap:Image;

	public inline function new(width:Int, height:Int) {
		albedoMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		emissionMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		normalMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		ormMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
	}

	var _width:Int = 0;
	var _height:Int = 0;

	public var width(get, set):Int;
	public var height(get, set):Int;

	inline function get_width():Int {
		return _width;
	}

	inline function set_width(value:Int):Int {
		_width = value;
		resize(_width, _height);
		return value;
	}

	inline function get_height():Int {
		return _height;
	}

	inline function set_height(value:Int):Int {
		_height = value;
		resize(_width, _height);
		return value;
	}

	public inline function resize(mapWidth:Int, mapHeight:Int):Void {
		_width = mapWidth;
		_height = mapHeight;
		
		albedoMap = resizeMap(albedoMap, mapWidth, mapHeight);
		emissionMap = resizeMap(emissionMap, mapWidth, mapHeight);
		normalMap = resizeMap(normalMap, mapWidth, mapHeight);
		ormMap = resizeMap(ormMap, mapWidth, mapHeight);
	}

	inline function resizeMap(map:Image, mapWidth:Int, mapHeight:Int) {
		var img = Image.createRenderTarget(mapWidth, mapHeight, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		setMap(img, map);
		return img;
	}

	public inline function setMap(map:Image, value:Image) {
		map.g2.begin();
		map.g2.drawScaledImage(value, 0, 0, map.width, map.height);
		map.g2.end();
	}

	public inline function setMapColor(map:Image, color:Color):Void {
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
