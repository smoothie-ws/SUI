package sui.core.shaders;

import kha.Canvas;

class EffectShaders {
	public static var Clear:Shader2D = new Shader2D();
	public static var Blur:BlurShader = new BlurShader();
	public static var Emission:EmissionShader = new EmissionShader();

	public static function clearEffects(buffer:Canvas):Void {
		Clear.apply(buffer);
	};
}
