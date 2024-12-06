package sui.stage2d.batches;

import kha.Color;
import kha.Image;

class MapBatch extends MapPack {
	var count:Int = 0;

	public inline function new(mapWidth:Int, mapHeight:Int, mapCount:Int = 4) {
		super(mapWidth, mapHeight, mapCount);
	}

	public inline function extend():Void {
		++count;
		for (i in 0...maps.length)
			maps[i] = extendMap(maps[i]);
	}

	override inline function resizeMap(map:Image):Image {
		var img = Image.createRenderTarget(mapWidth, mapHeight * count);
		img.g2.begin();
		img.g2.drawScaledImage(map, 0, 0, mapWidth, mapHeight * count);
		img.g2.end();
		return img;
	}

	inline function extendMap(map:Image):Image {
		var img = Image.createRenderTarget(mapWidth, mapHeight * count);
		img.g2.begin();
		img.g2.drawImage(map, 0, 0);
		img.g2.end();
		return img;
	}

	public inline function setMapInstance(map:Image, value:Image, instance:Int):Void {
		if (instance < 0 || instance >= count) {
			trace("Error: Instance index out of bounds");
			return;
		}
		map.g2.begin(false);
		map.g2.drawScaledImage(value, 0, instance * mapHeight, mapWidth, mapHeight);
		map.g2.end();
	}

	public inline function setMapInstanceColor(map:Image, color:Color, instance:Int):Void {
		if (instance < 0 || instance >= count) {
			trace("Error: Instance index out of bounds");
			return;
		}
		map.g2.begin(false);
		map.g2.color = color;
		map.g2.fillRect(0, instance * mapHeight, mapWidth, mapHeight);
		map.g2.end();
	}
}
