package sui;

import kha.Image;
// sui
import sui.elements.Element;
import sui.elements.DrawableElement;

@:structInit
class Scene extends DrawableElement {
	public var backbuffer:Image = null;

	var drawQueue:Array<DrawableElement> = [];

	inline function add(element:Element) {
		if (element.batchType != null) {
			var lastEl = cast drawQueue[drawQueue.length - 1];

			if (Type.getClass(lastEl) == element.batchType)
				lastEl.addChild(element);
			else {
				var batch = Type.createInstance(element.batchType, null);
				batch.add(cast element);
				drawQueue.push(batch);
			}
		} else if (element is DrawableElement) {
			drawQueue.push(cast element);
		}
		for (c in element.children)
			add(c);
	}

	override inline function addChild(element:Element) {
		children.push(element);
		element.parent = this;
		add(element);
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
