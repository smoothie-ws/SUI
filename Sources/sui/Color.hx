package sui;

import sui.utils.Math.arrMin;
import sui.utils.Math.arrMax;

enum abstract Color(Int) from Int from UInt to Int to UInt {
	var aliceblue = 0xfff0f8ff;
	var antiquewhite = 0xfffaebd7;
	var aqua = 0xff00ffff;
	var aquamarine = 0xff7fffd4;
	var azure = 0xfff0ffff;
	var beige = 0xfff5f5dc;
	var bisque = 0xffffe4c4;
	var black = 0xff000000;
	var blanchedalmond = 0xffffebcd;
	var blue = 0xff0000ff;
	var blueviolet = 0xff8a2be2;
	var brown = 0xffa52a2a;
	var burlywood = 0xffdeb887;
	var cadetblue = 0xff5f9ea0;
	var chartreuse = 0xff7fff00;
	var chocolate = 0xffd2691e;
	var coral = 0xffff7f50;
	var cornflowerblue = 0xff6495ed;
	var cornsilk = 0xfffff8dc;
	var crimson = 0xffdc143c;
	var cyan = 0xff00ffff;
	var darkblue = 0xff00008b;
	var darkcyan = 0xff008b8b;
	var darkgoldenrod = 0xffb8860b;
	var darkgray = 0xffa9a9a9;
	var darkgreen = 0xff006400;
	var darkgrey = 0xffa9a9a9;
	var darkkhaki = 0xffbdb76b;
	var darkmagenta = 0xff8b008b;
	var darkolivegreen = 0xff556b2f;
	var darkorange = 0xffff8c00;
	var darkorchid = 0xff9932cc;
	var darkred = 0xff8b0000;
	var darksalmon = 0xffe9967a;
	var darkseagreen = 0xff8fbc8f;
	var darkslateblue = 0xff483d8b;
	var darkslategray = 0xff2f4f4f;
	var darkslategrey = 0xff2f4f4f;
	var darkturquoise = 0xff00ced1;
	var darkviolet = 0xff9400d3;
	var deeppink = 0xffff1493;
	var deepskyblue = 0xff00bfff;
	var dimgray = 0xff696969;
	var dimgrey = 0xff696969;
	var dodgerblue = 0xff1e90ff;
	var firebrick = 0xffb22222;
	var floralwhite = 0xfffffaf0;
	var forestgreen = 0xff228b22;
	var fuchsia = 0xffff00ff;
	var gainsboro = 0xffdcdcdc;
	var ghostwhite = 0xfff8f8ff;
	var gold = 0xffffd700;
	var goldenrod = 0xffdaa520;
	var gray = 0xff808080;
	var grey = 0xff808080;
	var green = 0xff008000;
	var greenyellow = 0xffadff2f;
	var honeydew = 0xfff0fff0;
	var hotpink = 0xffff69b4;
	var indianred = 0xffcd5c5c;
	var indigo = 0xff4b0082;
	var ivory = 0xfffffff0;
	var khaki = 0xfff0e68c;
	var lavender = 0xffe6e6fa;
	var lavenderblush = 0xfffff0f5;
	var lawngreen = 0xff7cfc00;
	var lemonchiffon = 0xfffffacd;
	var lightblue = 0xffadd8e6;
	var lightcoral = 0xfff08080;
	var lightcyan = 0xffe0ffff;
	var lightgoldenrodyellow = 0xfffafad2;
	var lightgray = 0xffd3d3d3;
	var lightgreen = 0xff90ee90;
	var lightgrey = 0xffd3d3d3;
	var lightpink = 0xffffb6c1;
	var lightsalmon = 0xffffa07a;
	var lightseagreen = 0xff20b2aa;
	var lightskyblue = 0xff87cefa;
	var lightslategray = 0xff778899;
	var lightslategrey = 0xff778899;
	var lightsteelblue = 0xffb0c4de;
	var lightyellow = 0xffffffe0;
	var lime = 0xff00ff00;
	var limegreen = 0xff32cd32;
	var linen = 0xfffaf0e6;
	var magenta = 0xffff00ff;
	var maroon = 0xff800000;
	var mediumaquamarine = 0xff66cdaa;
	var mediumblue = 0xff0000cd;
	var mediumorchid = 0xffba55d3;
	var mediumpurple = 0xff9370db;
	var mediumseagreen = 0xff3cb371;
	var mediumslateblue = 0xff7b68ee;
	var mediumspringgreen = 0xff00fa9a;
	var mediumturquoise = 0xff48d1cc;
	var mediumvioletred = 0xffc71585;
	var midnightblue = 0xff191970;
	var mintcream = 0xfff5fffa;
	var mistyrose = 0xffffe4e1;
	var moccasin = 0xffffe4b5;
	var navajowhite = 0xffffdead;
	var navy = 0xff000080;
	var oldlace = 0xfffdf5e6;
	var olive = 0xff808000;
	var olivedrab = 0xff6b8e23;
	var orange = 0xffffa500;
	var orangered = 0xffff4500;
	var orchid = 0xffda70d6;
	var palegoldenrod = 0xffeee8aa;
	var palegreen = 0xff98fb98;
	var paleturquoise = 0xffafeeee;
	var palevioletred = 0xffdb7093;
	var papayawhip = 0xffffefd5;
	var peachpuff = 0xffffdab9;
	var peru = 0xffcd853f;
	var pink = 0xffffc0cb;
	var plum = 0xffdda0dd;
	var powderblue = 0xffb0e0e6;
	var purple = 0xff800080;
	var red = 0xffff0000;
	var rosybrown = 0xffbc8f8f;
	var royalblue = 0xff4169e1;
	var saddlebrown = 0xff8b4513;
	var salmon = 0xfffa8072;
	var sandybrown = 0xfff4a460;
	var seagreen = 0xff2e8b57;
	var seashell = 0xfffff5ee;
	var sienna = 0xffa0522d;
	var silver = 0xffc0c0c0;
	var skyblue = 0xff87ceeb;
	var slateblue = 0xff6a5acd;
	var slategray = 0xff708090;
	var slategrey = 0xff708090;
	var snow = 0xfffffafa;
	var springgreen = 0xff00ff7f;
	var steelblue = 0xff4682b4;
	var tan = 0xffd2b48c;
	var teal = 0xff008080;
	var thistle = 0xffd8bfd8;
	var tomato = 0xffff6347;
	var turquoise = 0xff40e0d0;
	var violet = 0xffee82ee;
	var wheat = 0xfff5deb3;
	var white = 0xffffffff;
	var whitesmoke = 0xfff5f5f5;
	var yellow = 0xffffff00;
	var yellowgreen = 0xff9acd32;
	var transparent = 0x00000000;

	// channels
	public var RGB(get, set):Array<Int>;
	public var RGBA(get, set):Array<Int>;
	public var R(get, set):Int;
	public var G(get, set):Int;
	public var B(get, set):Int;
	public var HSV(get, set):Array<Int>;
	public var HSVA(get, set):Array<Int>;
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
	inline function get_RGB():Array<Int> {
		return [R, G, B];
	}

	inline function set_RGB(value:Array<Int>):Array<Int> {
		if (value.length != 3)
			throw "Array length must be 3. Got: " + value.length;
		R = value[0];
		G = value[1];
		B = value[2];
		return value;
	}

	inline function get_RGBA():Array<Int> {
		return [R, G, B, A];
	}

	inline function set_RGBA(value:Array<Int>):Array<Int> {
		if (value.length != 3)
			throw "Array length must be 4. Got: " + value.length;
		R = value[0];
		G = value[1];
		B = value[2];
		A = value[3];
		return value;
	}

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
	inline function get_HSV():Array<Int> {
		return [H, S, V];
	}

	inline function set_HSV(value:Array<Int>):Array<Int> {
		if (value.length != 3)
			throw "Array length must be 3. Got: " + value.length;
		H = value[0];
		S = value[1];
		V = value[2];
		return value;
	}

	inline function get_HSVA():Array<Int> {
		return [H, S, V, A];
	}

	inline function set_HSVA(value:Array<Int>):Array<Int> {
		if (value.length != 3)
			throw "Array length must be 4. Got: " + value.length;
		H = value[0];
		S = value[1];
		V = value[2];
		A = value[3];
		return value;
	}

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

	// -------------------------------------------
	// init functions
	// -------------------------------------------
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

		var hexString = StringTools.hex(r, 2) + StringTools.hex(g, 2) + StringTools.hex(b, 2);
		if (a != 0xFF)
			hexString = StringTools.hex(a, 2) + hexString;

		return hexString;
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
