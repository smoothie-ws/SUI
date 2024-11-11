package sui.core.utils;

import kha.Color;
import kha.arrays.Float32Array;

class Float32ArrayExtension {
	public static inline function setArray(s:Float32Array, t:Dynamic, ?o:Int = 0) {
		for (i in 0...t.length) {
			var v = t[i];
			if (Std.isOfType(v, Array)) {
				setArray(s, v, o);
				o += v.length;
			} else {
				s[o + i] = cast v;
			}
		}
	}

	public static inline function setColor(s:Float32Array, c:Color, ?o:Int = 0) {
		setArray(s, [c.R, c.G, c.B, c.A], o);
	}
}
