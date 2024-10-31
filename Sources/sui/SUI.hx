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
import sui.core.graphics.Painters;

class SUI {
	public static var rawbuffer:Image;
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
		rawbuffer = Image.createRenderTarget(w, h);
	}

	public static inline function init(window:Window) {
		backbuffer = Image.createRenderTarget(window.width, window.height);
		rawbuffer = Image.createRenderTarget(window.width, window.height);

		window.notifyOnResize(resize);

		root.anchors.right.position = window.width;
		root.anchors.bottom.position = window.height;
		root.constructTree();
		Scheduler.addTimeTask(root.update, 0, 1 / 60);

		Assets.loadEverything(function() {
			compileShaders();
			System.notifyOnFrames(function(frames:Array<Framebuffer>) {
				backbuffer.g2.begin(true, root.color);
				backbuffer.g2.end();

				root.drawTree();

				frames[0].g2.begin(true);
				frames[0].g2.drawImage(backbuffer, 0, 0);
				frames[0].g2.end();
			});
		});
	}

	public static inline function compileShaders() {
		// painters
		Painters.Rect.compile(Shaders.image_vert, Shaders.rect_frag);
	}
}

@:structInit
class SUIOptions {
	public var title:String = "SUI App";
	public var width:Int = 800;
	public var height:Int = 600;
	public var samplesPerPixel:Int = 4;
}
