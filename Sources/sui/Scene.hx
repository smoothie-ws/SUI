package sui;

import kha.Color;
// sui
import sui.elements.Element;
import sui.elements.shapes.Rectangle;
import sui.core.graphics.painters.ElementPainter;
import sui.core.graphics.painters.RectPainter;

@:structInit
class Scene extends Element {
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

	public inline function update() {
		for (c in children)
			c.rotation += .01;
	};

	public inline function draw() {
		for (painter in painters)
			painter.draw(SUI.backbuffer);
	}
}
