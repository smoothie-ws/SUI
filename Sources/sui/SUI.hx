package sui;

import kha.Color;
import kha.Shaders;
import kha.Assets;
import kha.Window;
import kha.Scheduler;
import kha.System;
import kha.Framebuffer;
import kha.input.Mouse;
import kha.input.Keyboard;
import kha.graphics2.Graphics;
// sui
import sui.core.graphics.painters.shaders.PainterShaders;

class SUI {
	public static var window:Window;
	public static var mouse:Mouse;
	public static var keyboard:Keyboard;
	public static var cursor(never, set):MouseCursor;

	static function set_cursor(cursor:MouseCursor):MouseCursor {
		mouse.setSystemCursor(cursor);
		return cursor;
	}

	public static var scene:Scene = {};

	public static inline function start(?title:String = "SUI App", ?width:Int = 800, ?height:Int = 600, ?samplesPerPixel:Int = 1) {
		System.start({
			title: title,
			width: width,
			height: height,
			framebuffer: {samplesPerPixel: samplesPerPixel}
		}, function(window:Window) {
			init(window);
			System.notifyOnFrames(function(frames:Array<Framebuffer>) {
				render(frames[0].g2);
			});
		});
	}

	public static inline function stop() {
		System.stop();
	}

	public static inline function init(window:Window) {
		SUI.window = window;
		scene.resize(window.width, window.height);
		window.notifyOnResize(scene.resize);

		SUI.mouse = Mouse.get();
		SUI.keyboard = Keyboard.get();

		scene.constructTree();
		Scheduler.addTimeTask(scene.update, 0, 1 / 60);
		Assets.loadEverything(function() {
			compileShaders();
		});
	}

	public static inline function render(g2:Graphics, ?clear:Bool = true, clearColor:Color = Color.Transparent) {
		scene.draw();

		g2.begin(clear, clearColor);
		g2.drawImage(scene.backbuffer, 0, 0);
		g2.end();
	}

	public static inline function compileShaders() {
		PainterShaders.rectPainterShader.compile(Shaders.sui_rect_vert, Shaders.sui_rect_frag);
	}
}
