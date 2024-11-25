package sui;

import kha.Color;
import kha.Shaders;
import kha.Assets;
import kha.Window;
import kha.Scheduler;
import kha.System;
import kha.FastFloat;
import kha.Framebuffer;
import kha.input.Mouse;
import kha.input.Keyboard;
import kha.graphics2.Graphics;
// sui
import sui.core.graphics.SUIShaders;

class SUI {
	#if debug
	static var fst:FastFloat = 0;
	static var fpsCounter:Int = 0;
	static var fps:Int = 0;

	static inline function showFPS(g2:Graphics) {
		++fpsCounter;
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
	}
	#end

	public static var initialized:Bool = false;
	public static var scene:Scene = {};
	public static var options:SUIoptions = {vsync: true, samplesPerPixel: 1};
	public static var window:Window;
	// input vars
	public static var keyboard:Keyboard;
	public static var mouse:Mouse;
	@:isVar public static var cursor(get, set):MouseCursor;

	static inline function get_cursor():MouseCursor {
		return cursor;
	}

	static inline function set_cursor(value:MouseCursor):MouseCursor {
		cursor = value;
		mouse.setSystemCursor(value);
		return value;
	}

	static var onUpdateListeners:Array<Void->Void> = [];
	static var onRenderListeners:Array<Void->Void> = [];
	static var updateTaskId:Int;

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
		initialized = true;
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
		scene.draw(null);

		g2.begin(clear, clearColor);
		g2.drawImage(scene.backbuffer, 0, 0);
		#if debug
		showFPS(g2);
		#end
		g2.end();

		for (f in onRenderListeners)
			f();
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
