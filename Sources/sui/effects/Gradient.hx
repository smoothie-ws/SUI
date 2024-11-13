package sui.effects;

import kha.Color;
import kha.FastFloat;

@:structInit
class Gradient {
	public var start:Color = Color.White;
	public var end:Color = Color.Black;
	public var angle:FastFloat = 0.0;
	public var offset:FastFloat = 0.0;
	public var scale:FastFloat = 1.0;
}
