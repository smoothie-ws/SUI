package sui.stage2d.graphics;

import kha.Color;
import kha.Canvas;
// sui
import sui.core.graphics.DeferredRenderer;

class RenderPathDeffered implements RenderPath {
	var stage:Stage2D;
	var gbuffer:MapPack;

	public inline function new(stage:Stage2D) {
		this.stage = stage;
		gbuffer = new MapPack(1, 1, 4, RGBA32, DepthOnly, SUI.options.samplesPerPixel);
	}

	inline function resize(width:Int, height:Int) {
		gbuffer.resize(width, height);
	}

	inline function render(target:Canvas) {
		gbuffer[0].g4.begin([gbuffer[1], gbuffer[2], gbuffer[3]]);
		gbuffer[0].g4.clear(Color.Transparent, 0.0);
		#if SUI_STAGE2D_BATCHING
		for (batch in stage.batches)
			batch.drawGeometry(gbuffer[0]);
		#else
		for (sprite in stage.sprites)
			sprite.drawGeometry(gbuffer[0]);
		#end
		gbuffer[0].g4.end();

		target.g2.begin();
		target.g2.drawImage(gbuffer[0], 0, 0);
		// for (light in stage.lights) {
		// 	DeferredRenderer.lighting.draw(target, stage.vertices, stage.indices, [
		// 		gbuffer[0],
		// 		gbuffer[1],
		// 		gbuffer[2],
		// 		gbuffer[3],
		// 		light.x,
		// 		light.y,
		// 		light.z,
		// 		light.color.R,
		// 		light.color.G,
		// 		light.color.B,
		// 		light.power,
		// 		light.radius
		// 	]);
		// }
		target.g2.end();
	}
}
