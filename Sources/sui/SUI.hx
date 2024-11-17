package sui;

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
	public static var mouse:Mouse;
	public static var keyboard:Keyboard;

	@:isVar public static var cursor(get, set):MouseCursor;

	static function get_cursor():MouseCursor {
		return cursor;
	}

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
			Assets.loadEverything(function() {
				compileShaders();
				System.notifyOnFrames(function(frames:Array<Framebuffer>) {
					render(frames[0].g2);
				});
			});
		});
	}

	public static inline function stop() {
		System.stop();
	}

	public static inline function init(window:Window) {
		mouse = Mouse.get();
		keyboard = Keyboard.get();

		scene.resize(window.width, window.height);
		window.notifyOnResize(scene.resize);
		scene.constructTree();
		Scheduler.addTimeTask(scene.update, 0, 1 / 60);
	}

	public static inline function render(g2:Graphics) {
		scene.backbuffer.g2.begin(true, scene.backgroundColor);
		scene.draw();
		scene.backbuffer.g2.end();

		g2.begin();
		g2.drawImage(scene.backbuffer, 0, 0);
		g2.end();
	}

	public static inline function compileShaders() {
		PainterShaders.rectPainterShader.compile(Shaders.sui_rect_vert, Shaders.sui_rect_frag);
	}
}
