package sui.stage2d;

import kha.Color;
import kha.Image;

class GeometryMap {
	public var albedoMap:Image;
	public var emissionMap:Image;
	public var normalMap:Image;
	public var ormMap:Image;

	public inline function new(width:Int, height:Int) {
		albedoMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		emissionMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		normalMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		ormMap = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
	}

	inline function resizeMap(map:Image, mapWidth:Int, mapHeight:Int) {
		var img = Image.createRenderTarget(mapWidth, mapHeight, RGBA32, NoDepthAndStencil, SUI.options.samplesPerPixel);
		img.g2.begin();
		img.g2.drawScaledImage(map, 0, 0, img.width, img.height);
		img.g2.end();
		return img;
	}

	public inline function resize(mapWidth:Int, mapHeight:Int):Void {
		albedoMap = resizeMap(albedoMap, mapWidth, mapHeight);
		emissionMap = resizeMap(emissionMap, mapWidth, mapHeight);
		normalMap = resizeMap(normalMap, mapWidth, mapHeight);
		ormMap = resizeMap(ormMap, mapWidth, mapHeight);
	}

	public inline function get(index:Int):Image {
		switch (index) {
			case 0:
				return albedoMap;
			case 1:
				return emissionMap;
			case 2:
				return normalMap;
			case 3:
				return ormMap;
			default:
				return null;
		}
	}

	public inline function set(index:Int, value:Image):Void {
		switch (index) {
			case 0:
				albedoMap = value;
			case 1:
				emissionMap = value;
			case 2:
				normalMap = value;
			case 3:
				ormMap = value;
			default:
				null;
		}
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
