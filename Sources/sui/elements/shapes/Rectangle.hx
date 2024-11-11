package sui.elements.shapes;

import kha.FastFloat;
// sui
import sui.elements.Element;
import sui.effects.Border;
import sui.effects.Emission;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0;
	public var softness:FastFloat = 1;
	public var border:Border = {};
	public var emission:Emission = {};
}
