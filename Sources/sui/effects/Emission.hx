package sui.effects;

import kha.Color;
import kha.Image;
import kha.Canvas;
import kha.FastFloat;
// sui
import sui.core.shaders.EffectShaders;

@:structInit
class Emission extends Effect {
	public var size:FastFloat = 16.;
	public var offsetX:FastFloat = 0.;
	public var offsetY:FastFloat = 0.;
	public var color:Color = Color.Black;
	public var outer:Bool = true;
	public var quality:Int = 12;

	override public inline function apply(source:Image, target:Canvas) {
		EffectShaders.Emission.size = size;
		EffectShaders.Emission.quality = quality;
		EffectShaders.Emission.color = color;
		EffectShaders.Emission.offsetX = offsetX;
		EffectShaders.Emission.offsetY = offsetY;
		EffectShaders.Emission.resX = SUI.options.width;
		EffectShaders.Emission.resY = SUI.options.height;
		EffectShaders.Emission.outer = outer;
		EffectShaders.Emission.texture = source;
		EffectShaders.Emission.apply(target);
	}
}
