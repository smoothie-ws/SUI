package sui.core.graphics.batches;

import kha.Canvas;
// sui
import sui.elements.Element;

class DrawBatch extends Shader2D {
	public var elements:Array<Element> = [];

	public function new(?elements:Array<Element>) {
		if (elements != null)
			this.elements = elements;
	}

	public function draw(target:Canvas) {}
}
