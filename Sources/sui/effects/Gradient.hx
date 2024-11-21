package sui.effects;

import kha.Color;
import kha.FastFloat;

@:structInit
class Gradient {
	public var alignByElement:Bool = true;
	public var start:Color = Color.White;
	public var end:Color = Color.Black;
	public var angle:FastFloat = 90;
	public var position:FastFloat = 0.5;
	public var scale:FastFloat = 1.0;
}
