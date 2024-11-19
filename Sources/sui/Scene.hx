package sui;

import kha.Image;
// sui
import sui.elements.Element;
import sui.elements.BatchableElement;
import sui.elements.DrawableElement;
import sui.elements.shapes.Rectangle;
import sui.elements.batches.RectBatch;

@:structInit
class Scene extends DrawableElement {
	public var backbuffer:Image = null;

	var drawQueue:Array<DrawableElement> = [];

	public inline function add(element:Element) {
		addChild(element);
		for (c in element.children)
			add(c);

		if (element is BatchableElement) {
			var lastEl = cast drawQueue[drawQueue.length - 1];

			if (element is Rectangle) {
				if (lastEl is RectBatch && lastEl.children < 128)
					lastEl.addChild(element);
				else {
					var batch = new RectBatch();
					batch.addChild(element);
					drawQueue.push(batch);
				}
			}
		} else if (element is DrawableElement) {}
	};

	override public inline function resize(w:Int, h:Int) {
		width = w;
		height = h;

		var res = w > h ? w : h;
		backbuffer = Image.createRenderTarget(res, res);
	}

	public inline function update() {};

	override public inline function draw(_) {
		backbuffer.g2.begin(true, color);
		for (element in drawQueue)
			element.draw(backbuffer);
		backbuffer.g2.end();
	}
}
