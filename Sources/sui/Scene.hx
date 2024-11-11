package sui;

import sui.elements.Element;
import sui.elements.shapes.Rectangle;
import sui.core.graphics.batches.DrawBatch;

@:structInit
class Scene extends Element {
	var batches:Array<DrawBatch> = [];

	public inline function add(element:Element) {
		trace(Std.isOfType(element, Rectangle));
	};

	public inline function update() {};

	public inline function drawBatches() {
		for (batch in batches)
			batch.draw();
	}
}
