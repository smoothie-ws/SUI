package sui;

import sui.effects.Blur;

class Effects {
	public static function blur(?size:Float = 8., ?quality:Int = 12) {
		return new Blur(size, quality);
	}
}
