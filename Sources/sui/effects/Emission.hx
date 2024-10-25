package sui.effects;

import kha.Image;
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

	override public inline function apply(source:Image, target:Canvas) {
		EffectShaders.Emission.size = size;
		EffectShaders.Emission.quality = quality;
		EffectShaders.Emission.color = color;
		EffectShaders.Emission.offsetX = offsetX;
		EffectShaders.Emission.offsetY = offsetY;
		EffectShaders.Emission.resolutionX = SUI.options.width;
		EffectShaders.Emission.resolutionY = SUI.options.height;
		EffectShaders.Emission.texture = source;
		EffectShaders.Emission.apply(target);
	}
}
