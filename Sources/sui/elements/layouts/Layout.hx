package sui.elements.layouts;

import sui.elements.Element;
import sui.positioning.Alignment;

using sui.core.utils.ArrayExt;

class Layout extends Element {
	public var alignment:Alignment;

	public function new(?alignment:Alignment = Alignment.Center) {
		super();
		this.alignment = alignment;
	}

	override inline function addChild(element:Element) {
		children.push(element);
		element.parent = this;

		if ((alignment & Alignment.Left) != 0)
			element.anchors.left = left;
		if ((alignment & Alignment.Right) != 0)
			element.anchors.right = right;
		if ((alignment & Alignment.Top) != 0)
			element.anchors.top = top;
		if ((alignment & Alignment.Bottom) != 0)
			element.anchors.bottom = bottom;
		if ((alignment & Alignment.HCenter) != 0)
			element.anchors.horizontalCenter = horizontalCenter;
		if ((alignment & Alignment.VCenter) != 0)
			element.anchors.verticalCenter = verticalCenter;
	}
}
