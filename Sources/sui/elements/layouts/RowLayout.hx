package sui.elements.layouts;

import kha.FastFloat;
// sui
import sui.elements.Element;
import sui.positioning.Alignment;
import sui.positioning.Direction;
import sui.positioning.Anchors.AnchorLine;

class RowLayout extends Element {
	public var direction:Direction = Direction.TopToBottom;
	public var alignment:Alignment = Alignment.HCenter | Alignment.VCenter;
	public var spacing:FastFloat = 0.;

	var anchorLines(get, never):Array<AnchorLine>;

	inline function get_anchorLines():Array<AnchorLine> {
		var al:Array<AnchorLine> = [];
		var h = (bottom.position - top.position) / children.length;

		for (i in 1...children.length)
			al.push({
				position: i * h
			});

		return al;
	}

	override inline public function construct() {
		if (direction == Direction.BottomToTop)
			children.reverse();
		var al = anchorLines;
		children[0].anchors.set(left, top, right, al[0]);
		for (i in 1...children.length - 1)
			children[i].anchors.set(left, al[i - 1], right, al[i]);
		children[children.length - 1].anchors.set(left, al[al.length - 1], right, bottom);
	}
}
