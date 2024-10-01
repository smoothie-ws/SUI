package sui;

import kha.Framebuffer;
import kha.Window;
import kha.Display;
import kha.Scheduler;
import kha.FastFloat;
import kha.System;
import kha.Color;
import kha.graphics2.Graphics;
// sui
import sui.elements.Scene;

class SUI {
	public static var graphics:Graphics;
	public static var scene:Scene = {};

	public static inline function start(?options:SUIOptions) {
		if (options == null)
			options = {};
		System.start({
			width: options.width,
			height: options.height,
			framebuffer: {samplesPerPixel: options.samplesPerPixel}
		}, init);
	}

	public static inline function stop() {
		System.stop();
	}

	static inline function init(window:Window) {
		Scheduler.addTimeTask(scene.update, 0, 1 / Display.primary.frequency);
		System.notifyOnFrames(render);
	}

	static inline function render(frames:Array<kha.Framebuffer>) {
		SUI.graphics = frames[0].g2;
		SUI.graphics.begin(true, Color.fromBytes(255, 255, 255));
		scene.renderTree();
		SUI.graphics.end();
	}

	// colors
	public static inline function rgb(r:FastFloat, g:FastFloat, b:FastFloat) {
		return Color.fromFloats(r, g, b);
	}

	public static inline function rgba(r:FastFloat, g:FastFloat, b:FastFloat, a:FastFloat) {
		return Color.fromFloats(r, g, b, a);
	}

	public static inline function color(value:String) {
		return Color.fromString(value);
	}
}

@:structInit
class SUIOptions {
	public var title:String = "SUI App";
	public var width:Int = 800;
	public var height:Int = 600;
	public var samplesPerPixel:Int = 2;
}
