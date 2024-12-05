package sui.stage2d.batches;

import kha.Color;
import kha.Image;

class GBufferBatch extends GBuffer {
	var capacity:Int;

	public inline function new(width:Int, height:Int, capacity:Int = 64) {
		super(width, height * capacity);

		this.capacity = capacity;
	}

	override inline function resizeMap(map:Image):Image {
		var img = Image.createRenderTarget(width, height * capacity);
		img.g2.begin();
		img.g2.drawScaledImage(map, 0, 0, width, height * capacity);
		img.g2.end();

		return img;
	}

	public inline function setMapInstance(map:Image, value:Image, instance:Int) {
		map.g2.begin();
		map.g2.drawScaledImage(value, 0, instance * height, width, height);
		map.g2.end();
	}

	public inline function setMapInstanceColor(map:Image, color:Color, instance:Int):Void {
		map.g2.begin();
		map.g2.color = color;
		map.g2.fillRect(0, instance * height, width, height);
		map.g2.end();
	}
}
