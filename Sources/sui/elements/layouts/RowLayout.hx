package sui.elements.layouts;

import kha.Image;
import kha.FastFloat;
// sui
import sui.core.Element;
import sui.core.layouts.Alignment;
import sui.core.layouts.Direction;

@:structInit
class RowLayout extends Element {
	public var direction:Direction = Direction.LeftToRight | Direction.TopToBottom;
	public var alignment:Alignment = Alignment.HCenter | Alignment.VCenter;
	public var spacing:FastFloat = 0.;

	override public function drawTree():Image {
		if (visible) {
			final yDelta = finalH / children.length;
			var yOffset = 0.;

			switch (direction) {
				case Direction.BottomToTop:
					children.reverse();
			}

			for (child in children) {
				child.y = yOffset;
				child.drawTree();
				yOffset += yDelta;
			}
			return rawbuffers;
		} else
			return null;
	}
}
