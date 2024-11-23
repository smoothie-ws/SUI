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
#if debug
import kha.FastFloat;
#end
// sui
import sui.core.graphics.SUIShaders;

class SUI {
	public static var options:SUIoptions = {vsync: true, samplesPerPixel: 1};
	public static var window:Window;
	public static var mouse:Mouse;
	public static var keyboard:Keyboard;
	public static var cursor(never, set):MouseCursor;
	static var onUpdateListeners = [];
	static var onRenderListeners = [];
	static var updateTaskId:Int;
	#if debug
	static var fst:FastFloat = 0;
	static var fpsCounter:Int = 0;
	static var fps:Int = 0;
	#end

	static function set_cursor(cursor:MouseCursor):MouseCursor {
		mouse.setSystemCursor(cursor);
		return cursor;
	}

	public static var scene:Scene = {};

	public static inline function start(?title:String = "SUI App", ?width:Int = 800, ?height:Int = 600, ?vsync:Bool = true, ?samplesPerPixel:Int = 1) {
		options.vsync = vsync;
		options.samplesPerPixel = samplesPerPixel;
		System.start({
			title: title,
			width: width,
			height: height,
			framebuffer: {
				verticalSync: vsync,
				samplesPerPixel: samplesPerPixel
			}
		}, function(window:Window) {
			init(window);
			Assets.loadEverything(function() {
				System.notifyOnFrames(function(frames:Array<Framebuffer>) {
					render(frames[0].g2);
				});
			});
		});
	}

	public static inline function init(window:Window) {
		SUI.window = window;
		SUI.mouse = Mouse.get();
		SUI.keyboard = Keyboard.get();

		window.notifyOnResize(scene.resize);
		scene.resize(window.width, window.height);
		scene.constructTree();
		Assets.loadEverything(function() {
			compileShaders();
			startUpdates();
		});
	}

	public static inline function stop() {
		System.stop();
	}

	public static inline function render(g2:Graphics, ?clear:Bool = true, clearColor:Color = Color.Transparent) {
		for (f in onRenderListeners)
			f();
		scene.draw(null);

		g2.begin(clear, clearColor);
		g2.drawImage(scene.backbuffer, 0, 0);

		#if debug
		++ fpsCounter;
		var t = System.time;
		if (t - fst >= 1) {
			fps = fpsCounter;
			fpsCounter = 0;
			fst = t;
		}
		g2.font = Assets.fonts.get("Roboto_Regular");
		g2.fontSize = 14;
		g2.color = Color.Black;
		g2.drawString('FPS: ${fps}', 6, 6);
		g2.color = Color.White;
		g2.drawString('FPS: ${fps}', 5, 5);
		#end

		g2.end();
	}

	public static inline function compileShaders() {
		SUIShaders.rectShader.compile(Shaders.sui_rect_vert, Shaders.sui_rect_frag);
	}

	public static inline function update() {
		for (f in onUpdateListeners)
			f();
		scene.update();
	}

	public static inline function startUpdates() {
		updateTaskId = Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	public static inline function stopUpdates() {
		Scheduler.removeTimeTask(updateTaskId);
	}

	public static inline function notifyOnUpdate(f:Void->Void) {
		onUpdateListeners.push(f);
	}

	public static inline function removeUpdateListener(f:Void->Void) {
		onUpdateListeners.remove(f);
	}

	public static inline function notifyOnRender(f:Void->Void) {
		onRenderListeners.push(f);
	}

	public static inline function removeRenderListener(f:Void->Void) {
		onRenderListeners.remove(f);
	}
}

typedef SUIoptions = {
	var vsync:Bool;
	var samplesPerPixel:Int;
}
