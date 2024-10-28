package sui;

import kha.Color;
import sui.filters.Blur;
import sui.filters.Emission;

class Filters {
	public static inline function blur(?size:Float = 8., ?quality:Int = 12):Blur {
		return {
			size: size,
			quality: quality
		};
	}

	public static inline function emission(?size:Float = 16., ?offsetX:Float = 0., ?offsetY:Float = 0., ?outer:Bool = true, ?color:Color = Color.Black, ?quality:Int = 12):Emission {
		return {
			size: size,
			offsetX: offsetX,
			offsetY: offsetY,
			outer: outer,
			color: color,
			quality: quality
		};
	}
}
