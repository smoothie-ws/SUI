package sui;

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
	public static var scene:Scene;

	public static inline function start(options:SUIOptions) {
		System.start({width: options.width, height: options.height, framebuffer: {samplesPerPixel: options.samplesPerPixel}}, function(_) {
			Scheduler.addTimeTask(function() {
				scene.update();
			}, 0, 1 / Display.primary.frequency);
			System.notifyOnFrames(function(frames) {
				SUI.render(frames[0].g2);
			});
		});
	}

	public static inline function stop() {
		System.stop();
	}

	public static inline function render(graphics:Graphics) {
		SUI.graphics = graphics;
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

	public static inline function color(color:String) {
		return Color.fromString(color);
	}
}

typedef SUIOptions = {
	var title:String;
	var width:Int;
	var height:Int;
	var samplesPerPixel:Int;
}
