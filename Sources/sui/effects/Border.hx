package sui.effects;

import kha.Color;
import kha.FastFloat;

@:structInit
class Border {
	public var thickness:FastFloat = 2;
	public var softness:FastFloat = 1;
	public var color:Color = Color.Transparent;
}
