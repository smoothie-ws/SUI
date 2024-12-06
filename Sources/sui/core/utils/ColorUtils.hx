package sui.core.utils;

import kha.Color;
import kha.FastFloat;

class ColorUtils {
	public static inline function fromLinearFloats(r:FastFloat, g:FastFloat, b:FastFloat, a:FastFloat = 1):Color {
		return Color.fromFloats(Math.pow(r, 1.98), Math.pow(g, 1.98), Math.pow(b, 1.98), Math.pow(a, 1.98));
	}
}
