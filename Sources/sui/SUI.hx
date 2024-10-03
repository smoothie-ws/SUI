package sui;

import kha.Window;
import kha.Display;
import kha.Scheduler;
import kha.System;
import kha.Framebuffer;
import kha.graphics2.Graphics;
// sui
import sui.elements.Root;

class SUI {
	public static var graphics:Graphics;
	public static var root:Root = {
		anchors: {
			left: {position: 0.},
			top: {position: 0.}
		}
	};

	public static inline function start(?options:SUIOptions) {
		if (options == null)
			options = {};
		System.start({
			title: options.title,
			width: options.width,
			height: options.height,
			framebuffer: {samplesPerPixel: options.samplesPerPixel}
		}, init);
	}

	public static inline function stop() {
		System.stop();
	}

	static inline function init(window:Window) {
		Scheduler.addTimeTask(root.update, 0, 1 / Display.primary.frequency);
		System.notifyOnFrames(render);

		window.notifyOnResize(root.resize);
	}

	static inline function render(frames:Array<kha.Framebuffer>) {
		SUI.graphics = frames[0].g2;
		SUI.graphics.begin(true, cast(root.color, kha.Color));
		root.drawTree();
		SUI.graphics.end();
	}
}

@:structInit
class SUIOptions {
	public var title:String = "SUI App";
	public var width:Int = 800;
	public var height:Int = 600;
	public var samplesPerPixel:Int = 4;
}
