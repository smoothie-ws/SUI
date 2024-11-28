package sui.utils;

import kha.FastFloat;

class Units {
	public static inline function in2px(inches:FastFloat) {
		return inches * 96;
	}

	public static inline function cm2px(centimeters:FastFloat) {
		return centimeters * 37.8;
	}

	public static inline function mm2px(millimeters:FastFloat) {
		return millimeters * 3.78;
	}

	public static inline function Q2px(quarter_millimeters:FastFloat) {
		return quarter_millimeters * 0.945;
	}

	public static inline function pc2px(picas:FastFloat) {
		return picas * 16;
	}

	public static inline function pt2px(points:FastFloat) {
		return points * 1.33;
	}
}
