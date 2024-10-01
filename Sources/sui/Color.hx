package sui;

import sui.utils.Math.arrMin;
import sui.utils.Math.arrMax;
import kha.FastFloat;

enum abstract Color(Int) from Int from UInt to Int to UInt {
	public var R(get, set):Int;
	public var G(get, set):Int;
	public var B(get, set):Int;
	public var H(get, set):Int;
	public var S(get, set):Int;
	public var V(get, set):Int;
	public var A(get, set):Int;

	public function new(value:Int) {
		this = value;
	}

	// -------------------------------------------
	// RGB Getters and Setters
	// -------------------------------------------
	inline function get_R():Int {
		return ((this >> 16) & 0xFF);
	}

	inline function set_R(value:Int):Int {
		var intValue = Std.int(value) & 0xFF;
		this = (this & 0xFF00FFFF) | (intValue << 16);
		return value;
	}

	inline function get_G():Int {
		return ((this >> 8) & 0xFF);
	}

	inline function set_G(value:Int):Int {
		var intValue = Std.int(value) & 0xFF;
		this = (this & 0xFFFF00FF) | (intValue << 8);
		return value;
	}

	inline function get_B():Int {
		return (this & 0xFF);
	}

	inline function set_B(value:Int):Int {
		var intValue = Std.int(value) & 0xFF;
		this = (this & 0xFFFFFF00) | intValue;
		return value;
	}


	// -------------------------------------------
	// HSV + A Getters and Setters
	// -------------------------------------------
	inline function get_H():Int {
		var rgb = [R / 255, G / 255, B / 255];
		var cmax = arrMax(rgb);
		var cmin = arrMin(rgb);
		var d = cmax - cmin;

		if (cmax == rgb[0])
			return Std.int(60 * ((rgb[1] - rgb[2]) / d % 6));
		else if (cmax == rgb[1])
			return Std.int(60 * ((rgb[2] - rgb[0]) / d + 2));
		else
			return Std.int(60 * ((rgb[0] - rgb[1]) / d + 4));
	}

	inline function set_H(h:Int):Int {
		this = hsva(h, S, V, A);
		return h;
	}

	inline function get_S():Int {
		var rgb = [R / 255, G / 255, B / 255];
		var cmax = arrMax(rgb);
		var cmin = arrMin(rgb);
		var d = cmax - cmin;

		if (cmax == 0)
			return 0;
		else
			return Std.int(d / cmax * 100);
	}

	inline function set_S(s:Int):Int {
		this = hsva(H, s, V, A);
		return s;
	}

	inline function get_V():Int {
		var rgb = [R / 255, G / 255, B / 255];
		return Std.int(arrMax(rgb) * 100);
	}

	inline function set_V(v:Int):Int {
		this = hsva(H, S, v, A);
		return v;
	}

	inline function get_A():Int {
		return ((this >> 24) & 0xFF);
	}

	inline function set_A(value:Int):Int {
		var intValue = Std.int(value) & 0xFF;
		this = (this & 0x00FFFFFF) | (intValue << 24);
		return value;
	}

	public static inline function rgba(r:Int, g:Int, b:Int, a:Int = 255) {
		return new Color(a << 24 | r << 16 | g << 8 | b);
	}

	public static inline function hsva(h:Int, s:Int, v:Int, a:Int = 255) {
		h = h % 360;
		var sN = s / 100;
		var vN = v / 100;

		var c = sN * vN;
		var x = c * (1 - Math.abs((h / 60) % 2 - 1));
		var m = vN - c;

		var r = 0.;
		var g = 0.;
		var b = 0.;

		switch (Std.int(h / 60)) {
			case 0:
				r = c;
				g = x;
				b = 0;
			case 1:
				r = x;
				g = c;
				b = 0;
			case 2:
				r = 0;
				g = c;
				b = x;
			case 3:
				r = 0;
				g = x;
				b = c;
			case 4:
				r = x;
				g = 0;
				b = c;
			case 5:
				r = c;
				g = 0;
				b = x;
		}

		return rgba(Std.int((r + m) * 255), Std.int((g + m) * 255), Std.int((b + m) * 255), a);
	}

	public function toString():String {
		var r:Int = (this >> 16) & 0xFF;
		var g:Int = (this >> 8) & 0xFF;
		var b:Int = this & 0xFF;
		var a:Int = (this >> 24) & 0xFF;
		return StringTools.hex(a, 2) + StringTools.hex(r, 2) + StringTools.hex(g, 2) + StringTools.hex(b, 2);
	}

	public static function fromString(color:String):Color {
		if (color.charAt(0) == "#") {
			color = color.substr(1);
		}

		var len = color.length;
		var r:Int, g:Int, b:Int, a:Int = 255;

		switch (len) {
			case 6:
				r = Std.parseInt("0x" + color.substr(0, 2));
				g = Std.parseInt("0x" + color.substr(2, 2));
				b = Std.parseInt("0x" + color.substr(4, 2));
			case 8:
				a = Std.parseInt("0x" + color.substr(0, 2));
				r = Std.parseInt("0x" + color.substr(2, 2));
				g = Std.parseInt("0x" + color.substr(4, 2));
				b = Std.parseInt("0x" + color.substr(6, 2));
			default:
				throw "Invalid color string format.";
		}

		return rgba(r, g, b, a);
	}
}
