package sui;

import kha.Image;
// sui
import sui.elements.Element;
import sui.elements.DrawableElement;

using sui.core.utils.ArrayExt;

@:structInit
class Scene extends DrawableElement {
	public var resolution:Int = 0;
	public var backbuffer:Image = null;

	public inline function new() {
		super();
	}

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
		} else
			addChild(element);

		for (c in element.children)
			add(c);
	}

	override inline function resize(w:Int, h:Int) {
		width = w;
		height = h;
		createBackbuffer(w, h);
	}

	public inline function createBackbuffer(w:Int, h:Int) {
		resolution = w > h ? w : h;
		backbuffer = Image.createRenderTarget(resolution, resolution, null, NoDepthAndStencil);
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
