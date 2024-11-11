package sui.core.graphics.batches;

class RectBatch extends DrawBatch {
	public override inline function draw() {
		Painters.rectPainter.setRects(cast elements);
	}
}
