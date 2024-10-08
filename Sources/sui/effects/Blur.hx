package sui.effects;

import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.Image;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.graphics4.ConstantLocation;
// sui
import sui.effects.shaders.EffectShaders;

class Blur extends Effect {
	public var size:FastFloat;
	public var quality:Int;

	public function new(?size:Float = 8., ?quality:Int = 2) {
		this.size = size;
		this.quality = quality;
	}

	override public inline function apply(buffer:Image) {
		EffectShaders.Blur.apply(buffer, [size, quality]);
	}
}
