package sui;

import sui.SUI;

class App {
	public var title:String;
	public var width:Int;
	public var height:Int;
	public var vsync:Bool;
	public var samplesPerPixel:Int;

	@alias public var scene = SUI.scene;

	public function new(?title:String = "SUI App", ?width:Int = 800, ?height:Int = 600, ?vsync:Bool = true, ?samplesPerPixel:Int = 1) {
		this.title = title;
		this.width = width;
		this.height = height;
		this.vsync = vsync;
		this.samplesPerPixel = samplesPerPixel;
	}

	public function setup() {}
}
