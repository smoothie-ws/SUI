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
			extendMap(i);
	}

	override inline function resizeMap(mapID:Int):Void {
		var img = Image.createRenderTarget(mapWidth, mapHeight * count);
		img.g2.begin();
		img.g2.drawScaledImage(maps[mapID], 0, 0, mapWidth, mapHeight * count);
		img.g2.end();
		maps[mapID] = img;
	}

	inline function extendMap(mapID:Int):Void {
		var img = Image.createRenderTarget(mapWidth, mapHeight * count);
		img.g2.begin();
		img.g2.drawImage(maps[mapID], 0, 0);
		img.g2.end();
		maps[mapID] = img;
	}

	public inline function getMapInstance(mapID:Int, instanceID:Int):Image {
		var map = Image.createRenderTarget(mapWidth, mapHeight);
		map.g2.begin(true);
		map.g2.drawScaledSubImage(maps[mapID], 0, instanceID * mapHeight, mapWidth, mapHeight, 0, 0, mapWidth, mapHeight,);
		map.g2.end();
		return map;
	}

	public inline function setMapInstance(mapID:Int, value:Image, instanceID:Int):Void {
		maps[mapID].g2.begin(false);
		maps[mapID].g2.drawScaledImage(value, 0, instanceID * mapHeight, mapWidth, mapHeight);
		maps[mapID].g2.end();
	}

	public inline function setMapInstanceColor(mapID:Int, color:Color, instanceID:Int):Void {
		maps[mapID].g2.begin(false);
		maps[mapID].g2.color = color;
		maps[mapID].g2.fillRect(0, instanceID * mapHeight, mapWidth, mapHeight);
		maps[mapID].g2.end();
	}
}
