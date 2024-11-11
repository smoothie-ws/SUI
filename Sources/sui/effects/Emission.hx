package sui.effects;

import kha.Color;
import kha.FastFloat;

@:structInit
class Emission {
	public var offsetX:FastFloat = 0;
	public var offsetY:FastFloat = 0;
	public var softness:FastFloat = 15;
	public var size:FastFloat = 0;
	public var color:Color = Color.fromFloats(0.0, 0.0, 0.0, 0.5);
}
