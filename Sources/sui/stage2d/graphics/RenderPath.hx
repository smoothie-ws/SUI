package sui.stage2d.graphics;

import kha.Canvas;

@:allow(sui.stage2d.Stage2D)
interface RenderPath {
	private var stage:Stage2D;

	private function resize(width:Int, height:Int):Void;
	private function render(target:Canvas):Void;
}
