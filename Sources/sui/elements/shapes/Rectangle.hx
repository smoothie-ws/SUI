package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.elements.Element;
import sui.effects.Border;
import sui.effects.Emission;
import sui.effects.Gradient;

@:structInit
class Rectangle extends Element {
	public var color:Color = Color.White;
	public var softness:FastFloat = 1;
	public var radius:FastFloat = 0;
	public var topLeftRadius:FastFloat = Math.NaN;
	public var topRightRadius:FastFloat = Math.NaN;
	public var bottomLeftRadius:FastFloat = Math.NaN;
	public var bottomRightRadius:FastFloat = Math.NaN;
	public var border:Border = {};
	public var emission:Emission = {};
	public var gradient:Gradient = null;
}
