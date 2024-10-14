package sui;

import kha.Shaders;
import kha.Assets;
import kha.Window;
import kha.Scheduler;
import kha.System;
import kha.Framebuffer;
// sui
import sui.core.Root;
import sui.core.shaders.EffectShaders;
import sui.core.graphics.Painters;

class SUI {
	public static var root:Root = {
		anchors: {
			left: {position: 0.},
			top: {position: 0.}
		}
	};
	public static var options:SUIOptions;

	public static inline function start(?options:SUIOptions) {
		if (options == null)
			SUI.options = {};
		else
			SUI.options = options;

		System.start({
			title: SUI.options.title,
			width: SUI.options.width,
			height: SUI.options.height,
			framebuffer: {samplesPerPixel: SUI.options.samplesPerPixel}
		}, init);
	}

	public static inline function stop() {
		System.stop();
	}

	public static inline function resize(w:Int, h:Int) {
		options.width = w;
		options.height = h;
		root.resizeTree(w, h);
	}

	static inline function init(window:Window) {
		Assets.loadEverything(function() {
			window.notifyOnResize(resize);

			root.anchors.right.position = window.width;
			root.anchors.bottom.position = window.height;
			root.constructTree();

			Scheduler.addTimeTask(root.update, 0, 1 / 60);
			System.notifyOnFrames(function(frames:Array<kha.Framebuffer>) {
				root.renderToTarget(frames[0], true);
			});

			compileShaders();
		});
	}

	static inline function compileShaders() {
		// effects
		EffectShaders.Painter.compile();
		EffectShaders.Blur.compile(Shaders.blur_frag);
		// painters
		Painters.Rect.compile();
	}
}

@:structInit
class SUIOptions {
	public var title:String = "SUI App";
	public var width:Int = 800;
	public var height:Int = 600;
	public var samplesPerPixel:Int = 4;
}
