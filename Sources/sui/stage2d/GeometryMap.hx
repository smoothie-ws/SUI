package sui.stage2d;

import kha.Color;
import kha.Image;

class GeometryMap {
	@:isVar public var albedoMap(default, null):Image;
	@:isVar public var emissionMap(default, null):Image;
	@:isVar public var normalMap(default, null):Image;
	@:isVar public var ormMap(default, null):Image;

	public inline function new(width:Int, height:Int) {
		albedoMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		emissionMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		normalMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		ormMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
	}

	public inline function resize(mapWidth:Int, mapHeight:Int):Void {
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
