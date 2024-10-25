package sui.effects;

import kha.Image;
import kha.Canvas;
import kha.FastFloat;
// sui
import sui.core.shaders.EffectShaders;

class Blur extends Effect {
	public var size:FastFloat;
	public var quality:Int;

	public function new(?size:Float = 8., ?quality:Int = 12) {
		this.size = size;
		this.quality = quality;
	}

	override public inline function apply(source:Image, target:Canvas) {
		EffectShaders.Blur.size = size;
		EffectShaders.Blur.quality = quality;
		EffectShaders.Blur.resolutionX = SUI.options.width;
		EffectShaders.Blur.resolutionY = SUI.options.height;
		EffectShaders.Blur.texture = source;
		EffectShaders.Blur.apply(target);
	}
}
