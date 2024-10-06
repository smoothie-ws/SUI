package sui.elements.layouts;

import kha.FastFloat;

@:structInit
class RowLayout extends Element {
	public var direction:Direction = Direction.Default;
	public var alignment:Alignment = Alignment.Default;
	public var spacing:FastFloat = 0.;

	override public function drawTree() {
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
		}
	}
}
