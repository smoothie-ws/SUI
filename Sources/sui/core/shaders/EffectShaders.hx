package sui.core.shaders;

import kha.Canvas;

class EffectShaders {
	public static var Painter:Shader = new Shader();
	public static var Blur:BlurShader = new BlurShader();

	public static function clearEffects(buffer:Canvas):Void {
		Painter.apply(buffer, []);
	};
}
