package sui;

import kha.Assets;
import kha.Window;
import kha.Scheduler;
import kha.System;
import kha.Framebuffer;
import kha.graphics2.Graphics;
// sui
import sui.elements.Root;

class SUI {
	static var _options:SUIOptions = {};
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
		_options = options;

		System.start({
			title: _options.title,
			width: _options.width,
			height: _options.height,
			framebuffer: {samplesPerPixel: _options.samplesPerPixel}
		}, init);
	}

	public static inline function stop() {
		System.stop();
	}

	static inline function init(window:Window) {
		Assets.loadEverything(function() {
			window.notifyOnResize(root.resize);
			window.resize(_options.width, _options.height);
			root.constructTree();

			Scheduler.addTimeTask(root.update, 0, 1 / 60);
			System.notifyOnFrames(render);
		});
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
