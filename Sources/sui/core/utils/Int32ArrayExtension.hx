package sui.core.utils;

import kha.arrays.Int32Array;

class Int32ArrayExtension {
	public static function fromArray(s:Int32Array, t:Dynamic, ?o:Int = 0) {
		for (i in 0...t.length) {
			var v = t[i];
			if (Std.isOfType(v, Array)) {
				fromArray(s, v, o);
				o += v.length;
			} else {
				s[o + i] = cast v;
			}
		}
	}
}
