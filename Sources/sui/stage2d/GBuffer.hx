package sui.stage2d;

import kha.Color;
import kha.Image;

class GBuffer {
	@readonly public var albedo:Image;
	@readonly public var emission:Image;
	@readonly public var normal:Image;
	@readonly public var orm:Image;

	@readonly public var width:Int;
	@readonly public var height:Int;

	public inline function new() {
		albedo = Image.createRenderTarget(1, 1);
		emission = Image.createRenderTarget(1, 1);
		normal = Image.createRenderTarget(1, 1);
		orm = Image.createRenderTarget(1, 1);
	}

	public inline function resize(mapWidth:Int, mapHeight:Int):Void {
		width = mapWidth;
		height = mapHeight;

		if (width > 0 && height > 0) {
			albedo = resizeMap(albedo);
			emission = resizeMap(emission);
			normal = resizeMap(normal);
			orm = resizeMap(orm);
		}
	}

	function resizeMap(map:Image):Image {
		var img = Image.createRenderTarget(width, height);
		img.g2.begin();
		img.g2.drawScaledImage(map, 0, 0, width, height);
		img.g2.end();

		return img;
	}

	public inline function setMap(map:Image, value:Image) {
		map.g2.begin();
		map.g2.drawScaledImage(value, 0, 0, width, height);
		map.g2.end();
	}

	public inline function setMapColor(map:Image, color:Color):Void {
		map.g2.begin();
		map.g2.color = color;
		map.g2.fillRect(0, 0, width, height);
		map.g2.end();
	}
}
