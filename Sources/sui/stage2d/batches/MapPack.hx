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
				resizeMap(i);
	}

	private function resizeMap(mapID:Int):Void {
		var img = Image.createRenderTarget(mapWidth, mapHeight);
		img.g2.begin();
		img.g2.drawScaledImage(maps[mapID], 0, 0, mapWidth, mapHeight);
		img.g2.end();

		maps[mapID] = img;
	}

	public inline function setMap(mapID:Int, value:Image) {
		maps[mapID].g2.begin();
		maps[mapID].g2.drawScaledImage(value, 0, 0, mapWidth, mapHeight);
		maps[mapID].g2.end();
	}

	public inline function setMapColor(mapID:Int, color:Color):Void {
		maps[mapID].g2.begin();
		maps[mapID].g2.color = color;
		maps[mapID].g2.fillRect(0, 0, mapWidth, mapHeight);
		maps[mapID].g2.end();
	}
}
