package sui.core.graphics.batches;

import kha.Canvas;

class RectBatch extends DrawBatch {
	public override inline function draw(target:Canvas) {
		Painters.rectPainter.setRects(cast elements);
		Painters.rectPainter.apply(target);
	}
}
