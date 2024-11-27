package sui.elements.layouts;

import kha.FastFloat;
// sui
import sui.elements.Element;
import sui.positioning.Alignment;
import sui.positioning.Direction;

using sui.core.utils.ArrayExt;

class RowLayout extends Element {
	public var spacing:FastFloat = 0.;
	public var direction:Direction = Direction.TopToBottom;
	public var alignment:Alignment = Alignment.HCenter | Alignment.VCenter;

	override inline function construct() {
		if (direction == Direction.BottomToTop)
			children.reverse();

		var h = height / children.length;

		children[0].anchors.top = top;
		children[0].height = h;
		if ((alignment & Alignment.VCenter) != 0)
			children[0].anchors.verticalCenter = verticalCenter;

		for (i in 1...children.length) {
			children[i].anchors.top = children[i - 1].top;
			children[i].anchors.topMargin = spacing;
			children[i].height = h;
			if ((alignment & Alignment.VCenter) != 0)
				children[i].anchors.verticalCenter = verticalCenter;
		}
	}
}
