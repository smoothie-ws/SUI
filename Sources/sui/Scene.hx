package sui;

import kha.Image;
// sui
import sui.elements.Element;
import sui.elements.DrawableElement;

using sui.core.utils.ArrayExtension;

@:structInit
class Scene extends DrawableElement {
	public var drawQueue:Array<DrawableElement> = [];
	public var backbuffer:Image = null;

	override inline function addChild(element:Element) {
		children.push(element);
		element.parent = this;
		if (SUI.initialized)
			add(element);
	};

	override inline function construct() {
		for (c in children)
			add(c);
	}

	inline function add(element:Element) {
		if (element.batchType != null) {
			var lastEl = cast drawQueue.last();
			if (Type.getClass(lastEl) == element.batchType)
				lastEl.addChild(element);
			else {
				var batch = Type.createInstance(element.batchType, null);
				batch.addChild(element);
				drawQueue.push(batch);
			}
		} else if (element is DrawableElement) {
			drawQueue.push(cast element);
		}
		for (c in element.children)
			add(c);
	}

	override inline function resize(w:Int, h:Int) {
		width = w;
		height = h;

		var res = w > h ? w : h;
		backbuffer = Image.createRenderTarget(res, res, null, NoDepthAndStencil, SUI.options.samplesPerPixel);
	}

	public inline function update() {};

	override inline function draw(_) {
		backbuffer.g2.begin(true, color);
		for (element in drawQueue)
			element.draw(backbuffer);
		backbuffer.g2.end();
	}
}
