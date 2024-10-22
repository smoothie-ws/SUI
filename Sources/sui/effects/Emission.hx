package sui.effects;

import kha.Canvas;
import kha.FastFloat;
// sui
import sui.core.shaders.EffectShaders;

class Emission extends Effect {
	public var size:FastFloat;
	public var offsetX:FastFloat;
	public var offsetY:FastFloat;
	public var color:Color;
	public var outer:Bool;
	public var quality:Int;

	public function new(?size:Float = 16., ?offsetX:Float = 0., ?offsetY:Float = 0., ?color:Color = Color.black, outer:Bool = true, ?quality:Int = 12) {
		this.size = size;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.color = color;
		this.outer = outer;
		this.quality = quality;
	}

	override public inline function apply(buffer:Canvas) {
		EffectShaders.Emission.apply(buffer, size, offsetX, offsetY, color, outer, quality);
	}
}
