package sui;

import kha.Image;
// sui
import sui.elements.Element;
import sui.elements.DrawableElement;

using sui.core.utils.ArrayExt;

@:structInit
class Scene extends DrawableElement {
	public var backbuffer:Image = null;

	public inline function add(element:Element) {
		if (element.batchType != null) {
			var lastEl = cast children.last();
			if (Type.getClass(lastEl) == element.batchType)
				lastEl.addChild(element);
			else {
				var batch = Type.createInstance(element.batchType, null);
				batch.addChild(element);
				addChild(batch);
			}
		} else if (element is DrawableElement) {
			addChild(element);
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
		for (c in children)
			if (c is DrawableElement)
				cast(c, DrawableElement).draw(backbuffer);
		backbuffer.g2.end();
	}
}
