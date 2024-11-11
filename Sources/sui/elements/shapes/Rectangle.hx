package sui.elements.shapes;

import sui.core.Emission;
import sui.core.Border;
import kha.FastFloat;
// sui
import sui.core.Element;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0;
	public var softness:FastFloat = 1;
	public var border:Border = {};
	public var emission:Emission = {};
}
