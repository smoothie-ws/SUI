package sui.elements.layouts;

import sui.elements.Element;
import sui.positioning.Alignment;

using sui.core.utils.ArrayExt;

class Layout extends Element {
	public var alignment:Alignment;

	public function new(?alignment:Alignment = Alignment.HCenter | Alignment.VCenter) {
		super();
		this.alignment = alignment;
	}

	inline function add(e:Element) {
		if ((alignment & Alignment.Left) != 0)
			e.anchors.left = left;
		if ((alignment & Alignment.Right) != 0)
			e.anchors.right = right;
		if ((alignment & Alignment.Top) != 0)
			e.anchors.top = top;
		if ((alignment & Alignment.Bottom) != 0)
			e.anchors.bottom = bottom;
		if ((alignment & Alignment.HCenter) != 0)
			e.anchors.horizontalCenter = horizontalCenter;
		if ((alignment & Alignment.VCenter) != 0)
			e.anchors.verticalCenter = verticalCenter;
	}

	override inline function addChild(element:Element) {
		children.push(element);
		element.parent = this;
		add(element);
	}
}
