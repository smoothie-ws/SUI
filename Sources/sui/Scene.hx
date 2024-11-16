package sui;

import kha.Image;
import kha.Color;
// sui
import sui.elements.Element;
import sui.elements.shapes.Rectangle;
import sui.core.graphics.painters.ElementPainter;
import sui.core.graphics.painters.RectPainter;

@:structInit
class Scene extends Element {
	public var rawbuffer:Image = null;
	public var backbuffer:Image = null;

	var painters:Array<ElementPainter> = [];

	public var backgroundColor:Color = Color.White;

	public inline function add(element:Element) {
		addChild(element);

		var lastPainter = painters[painters.length - 1];

		if (element is Rectangle) {
			if (lastPainter is RectPainter && lastPainter.elements.length < 64)
				lastPainter.elements.push(element);
			else {
				var rectPainter = new RectPainter();
				rectPainter.elements.push(cast element);
				painters.push(rectPainter);
			}
		}
	};

	override public inline function resize(w:Int, h:Int) {
		width = w;
		height = h;

		var res = w > h ? w : h;
		rawbuffer = Image.createRenderTarget(res, res);
		backbuffer = Image.createRenderTarget(res, res);
	}

	public inline function update() {};

	public inline function draw() {
		for (painter in painters)
			painter.draw(backbuffer);
	}
}
