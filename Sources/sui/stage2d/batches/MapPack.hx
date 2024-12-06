package sui.stage2d.batches;

import kha.Color;
import kha.Image;

class MapPack {
	@readonly public var maps:Array<Image> = [];
	@readonly public var mapWidth:Int;
	@readonly public var mapHeight:Int;

	public inline function new(mapWidth:Int, mapHeight:Int, mapCount:Int = 4) {
		this.mapWidth = mapWidth;
		this.mapHeight = mapHeight;
		for (_ in 0...mapCount)
			maps.push(Image.createRenderTarget(mapWidth, mapHeight));
	}

	public inline function resize(mapWidth:Int, mapHeight:Int):Void {
		this.mapWidth = mapWidth;
		this.mapHeight = mapHeight;

		if (mapWidth > 0 && mapHeight > 0)
			for (i in 0...maps.length)
				maps[i] = resizeMap(maps[i]);
	}

	private function resizeMap(map:Image):Image {
		if (map.width == mapWidth && map.height == mapHeight)
			return map;
		var img = Image.createRenderTarget(mapWidth, mapHeight);
		img.g2.begin();
		img.g2.drawScaledImage(map, 0, 0, mapWidth, mapHeight);
		img.g2.end();
		return img;
	}

	public inline function setMap(map:Image, value:Image) {
		map.g2.begin();
		map.g2.drawScaledImage(value, 0, 0, mapWidth, mapHeight);
		map.g2.end();
	}

	public inline function setMapColor(map:Image, color:Color):Void {
		map.g2.begin();
		map.g2.color = color;
		map.g2.fillRect(0, 0, mapWidth, mapHeight);
		map.g2.end();
	}
}
