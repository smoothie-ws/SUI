package sui;

import sui.elements.Element;
import sui.elements.shapes.Rectangle;
import sui.core.graphics.batches.RectBatch;
import sui.core.graphics.batches.DrawBatch;

@:structInit
class Scene extends Element {
	var batches:Array<DrawBatch> = [];

	public inline function add(element:Element) {
		batches.push(new RectBatch([element]));
	};

	public inline function update() {};

	public inline function drawBatches() {
		for (batch in batches)
			batch.draw(SUI.backbuffer);
	}
}
