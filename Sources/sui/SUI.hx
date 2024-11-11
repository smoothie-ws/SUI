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
	public static var window:Window;
	public static var rawbuffer:Image;
	public static var backbuffer:Image;
	public static var root:Root = {};

	public static inline function start(?title:String = "SUI App", ?width:Int = 800, ?height:Int = 600, ?samplesPerPixel:Int = 1) {
		System.start({
			title: title,
			width: width,
			height: height,
			framebuffer: {samplesPerPixel: samplesPerPixel}
		}, init);
	}

	public static inline function stop() {
		System.stop();
	}

	public static inline function resize(w:Int, h:Int) {
		backbuffer = Image.createRenderTarget(w, h);
		rawbuffer = Image.createRenderTarget(w, h);
	}

	public static inline function init(window:Window) {
		SUI.window = window;
		window.notifyOnResize(resize);

		backbuffer = Image.createRenderTarget(window.width, window.height);
		rawbuffer = Image.createRenderTarget(window.width, window.height);

		Scheduler.addTimeTask(root.update, 0, 1 / 60);

		Assets.loadEverything(function() {
			compileShaders();
			System.notifyOnFrames(function(frames:Array<Framebuffer>) {
				root.drawBatches();
				frames[0].g2.begin(true);
				frames[0].g2.drawImage(backbuffer, 0, 0);
				frames[0].g2.end();
			});
		});
	}

	public static inline function compileShaders() {
		Painters.rectPainter.compile(Shaders.image_vert, Shaders.rect_frag);
	}
}
