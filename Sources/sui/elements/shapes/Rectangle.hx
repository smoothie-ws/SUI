package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.effects.Gradient;

class Rectangle extends BatchableElement {
	public var color:Color = Color.White;
	public var softness:FastFloat = 1;
	public var radius:FastFloat = 0;
	public var gradient:Gradient = null;

	override function set_x(value:FastFloat):FastFloat {
		x = value;
		left.position = x;
		return value;
	}
}
