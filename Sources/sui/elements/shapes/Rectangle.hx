package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.effects.Gradient;
import sui.elements.batches.RectBatch;

class Rectangle extends Element {
	public var color:Color = Color.White;
	public var softness:FastFloat = 1;
	public var radius:FastFloat = 0;
	public var gradient:Gradient = null;

	override inline function get_batchType() {
		return RectBatch;
	}
}
