package sui.core.shaders;

import kha.Image;

class EffectShaders {
	public static var Painter:Shader = new Shader();
	public static var Blur:BlurShader = new BlurShader();

	public static function clearEffects(buffer:Image):Void {
		Painter.apply(buffer, []);
	};
}
