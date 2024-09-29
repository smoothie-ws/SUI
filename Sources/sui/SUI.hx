package sui;

import kha.FastFloat;
import kha.System;
import kha.Color;
import kha.graphics2.Graphics;

class SUI {
	public static var graphics:Graphics;
	public static var app:Element = new Element();

	public static inline function render(graphics:Graphics) {
		SUI.graphics = graphics;
		SUI.graphics.begin(true, Color.fromBytes(255, 255, 255));
		app.drawAll();
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

	public static inline function start() {
		System.start({title: "Project", width: 1024, height: 768}, function(_) {
			System.notifyOnFrames(function(frames) {
				SUI.render(frames[0].g2);
			});
		});
	}
}
