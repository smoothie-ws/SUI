package sui.core.utils;

import kha.Color;
import kha.arrays.Float32Array;

class Float32ArrayExtension {
	public static inline function fromArray(s:Float32Array, a:Dynamic, ?o:Int = 0) {
		for (i in 0...a.length) {
			var v = a[i];
			if (Std.isOfType(v, Array)) {
				fromArray(s, v, o);
				o += v.length;
			} else {
				s[o + i] = cast v;
			}
		}
	}

	public static inline function fromColor(s:Float32Array, c:Color, ?o:Int = 0) {
		fromArray(s, [c.R, c.G, c.B, c.A], o);
	}
}
