package sui.filters;

import kha.Color;
import kha.Image;
import kha.Canvas;
import kha.FastFloat;
// sui
import sui.core.shaders.FilterShaders;

@:structInit
class Emission extends Filter {
	public var size:FastFloat = 16.;
	public var offsetX:FastFloat = 0.;
	public var offsetY:FastFloat = 0.;
	public var color:Color = Color.Black;
	public var outer:Bool = true;
	public var quality:Int = 12;

	override public inline function apply(source:Image, target:Canvas) {
		FilterShaders.Emission.size = size;
		FilterShaders.Emission.quality = quality;
		FilterShaders.Emission.color = color;
		FilterShaders.Emission.offsetX = offsetX;
		FilterShaders.Emission.offsetY = offsetY;
		FilterShaders.Emission.resX = SUI.options.width;
		FilterShaders.Emission.resY = SUI.options.height;
		FilterShaders.Emission.outer = outer;
		FilterShaders.Emission.texture = source;
		FilterShaders.Emission.apply(target);
	}
}
