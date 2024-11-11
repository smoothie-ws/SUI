package sui;

import kha.Color;
// sui
import sui.elements.Element;
import sui.elements.shapes.Rectangle;
import sui.core.graphics.batches.RectBatch;
import sui.core.graphics.batches.DrawBatch;

@:structInit
class Scene {
	var batches:Array<DrawBatch> = [new RectBatch()];

	public var color:Color = Color.White;

	public inline function add(element:Element) {
		if (element is Rectangle) {
			trace(batches[-1] is RectBatch);
			if (batches[-1] is RectBatch)
				batches[-1].elements.push(element);
			else
				batches.push(new RectBatch([element]));
		}
	};

	public inline function remove(element:Element) {
		for (batch in batches)
			if (batch is RectBatch) {
				batch.elements.remove(element);
				if (batch.elements.length == 0)
					batches.remove(batch);
			}
	};

	public inline function update() {};

	public inline function drawBatches() {
		for (batch in batches)
			batch.draw(SUI.backbuffer);
	}
}
