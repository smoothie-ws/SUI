package sui.layouts;

import kha.FastFloat;
// sui
import sui.elements.Element;

@:structInit
class RowLayout extends Element {
	public var direction:Direction = Direction.Default;
	public var alignment:Alignment = Alignment.Default;
	public var spacing:FastFloat = 0.;

	override public function renderTree() {
		if (visible) {
			final yDelta = finalH / children.length;
			var yOffset = 0.;

			switch (direction) {
				case Direction.BottomToTop:
					children.reverse();
			}

			for (child in children) {
				child.y = yOffset;
				child.renderTree();
				yOffset += yDelta;
			}
		}
	}
}
