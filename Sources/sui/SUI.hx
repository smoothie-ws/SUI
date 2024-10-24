package sui;

import kha.Image;
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
	public static var rawbackbuffer:Image;
	public static var backbuffer:Image;

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

		backbuffer = Image.createRenderTarget(w, h);
		rawbackbuffer = Image.createRenderTarget(w, h);
	}

	public static inline function init(window:Window) {
		backbuffer = Image.createRenderTarget(window.width, window.height);
		rawbackbuffer = Image.createRenderTarget(window.width, window.height);
		window.notifyOnResize(resize);

		root.anchors.right.position = window.width;
		root.anchors.bottom.position = window.height;
		root.constructTree();
		Scheduler.addTimeTask(root.update, 0, 1 / 60);

		Assets.loadEverything(function() {
			compileShaders();
			System.notifyOnFrames(function(frames:Array<kha.Framebuffer>) {
				root.drawTree();

				var g2 = frames[0].g2;
				g2.begin(true, kha.Color.fromValue(root.color));
				g2.drawImage(backbuffer, 0., 0.);
				g2.end();
			});
		});
	}

	public static inline function compileShaders() {
		// effects
		EffectShaders.Clear.compile();
		EffectShaders.Blur.compile(Shaders.blur_frag);
		EffectShaders.Emission.compile(Shaders.emission_frag);

		// painters
		Painters.Rect.compile();
		Painters.Ellipse.compile();
	}
}

@:structInit
class SUIOptions {
	public var title:String = "SUI App";
	public var width:Int = 800;
	public var height:Int = 600;
	public var samplesPerPixel:Int = 4;
}
