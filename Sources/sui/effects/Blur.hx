package sui.effects;

import kha.Image;
import kha.FastFloat;
// sui
import sui.effects.shaders.EffectShaders;

class Blur extends Effect {
	public var size:FastFloat;
	public var quality:Int;

	public function new(?size:Float = 8., ?quality:Int = 12) {
		this.size = size;
		this.quality = quality;
	}

	override public inline function apply(buffer:Image) {
		EffectShaders.Blur.apply(buffer, [size, quality]);
	}
}
