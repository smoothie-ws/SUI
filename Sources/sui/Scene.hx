package sui.core;

import sui.core.graphics.batches.DrawBatch;

@:structInit
class Scene {
	var batches:Array<DrawBatch> = [];

	public inline function update() {};

	public inline function drawBatches() {
		for (batch in batches)
			batch.draw();
	}
}
