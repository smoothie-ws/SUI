package sui.filters;

import kha.Image;
import kha.Canvas;
import kha.FastFloat;
// sui
import sui.core.shaders.FilterShaders;

@:structInit
class Blur extends Filter {
	public var size:FastFloat = 16.;
	public var quality:Int = 16;

	override public inline function apply(source:Image, target:Canvas) {
		FilterShaders.Blur.size = size;
		FilterShaders.Blur.quality = quality;
		FilterShaders.Blur.resX = SUI.options.width;
		FilterShaders.Blur.resY = SUI.options.height;
		FilterShaders.Blur.texture = source;
		FilterShaders.Blur.apply(target);
	}
}
