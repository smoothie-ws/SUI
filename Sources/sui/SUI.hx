package sui;

import kha.Image;
import kha.Shaders;
import kha.Assets;
import kha.Window;
import kha.Scheduler;
import kha.System;
import kha.Framebuffer;
// sui
import sui.core.graphics.painters.shaders.PainterShaders;

class SUI {
	public static var window:Window;
	public static var rawbuffer:Image;
	public static var backbuffer:Image;
	public static var scene:Scene = {};

	public static inline function start(?title:String = "SUI App", ?width:Int = 800, ?height:Int = 600, ?samplesPerPixel:Int = 1) {
		System.start({
			title: title,
			width: width,
			height: height,
			framebuffer: {samplesPerPixel: samplesPerPixel}
		}, function(window:Window) {
			init(window);
			Assets.loadEverything(function() {
				compileShaders();
				System.notifyOnFrames(function(frames:Array<Framebuffer>) {
					render(frames[0]);
				});
			});
		});
	}

	public static inline function stop() {
		System.stop();
	}

	public static inline function resize(w:Int, h:Int) {
		var _res = w > h ? w : h;
		rawbuffer = Image.createRenderTarget(_res, _res);
		backbuffer = Image.createRenderTarget(_res, _res);

		scene.resize(w, h);
	}

	public static inline function init(window:Window) {
		SUI.window = window;
		window.notifyOnResize(resize);

		var _res = window.width > window.height ? window.width : window.height;
		rawbuffer = Image.createRenderTarget(_res, _res);
		backbuffer = Image.createRenderTarget(_res, _res);

		Scheduler.addTimeTask(scene.update, 0, 1 / 60);
	}

	public static inline function render(fb:Framebuffer) {
		SUI.backbuffer.g2.begin(true, scene.backgroundColor);
		scene.draw();
		SUI.backbuffer.g2.end();

		fb.g2.begin();
		fb.g2.drawImage(backbuffer, 0, 0);
		fb.g2.end();
	}

	public static inline function compileShaders() {
		PainterShaders.rectPainterShader.compile(Shaders.rect_vert, Shaders.rect_frag);
	}
}
