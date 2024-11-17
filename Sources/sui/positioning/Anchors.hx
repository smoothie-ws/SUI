package sui.positioning;

import kha.FastFloat;
// sui
import sui.elements.Element;

class Anchors {
	public var top:AnchorLine = {};
	public var left:AnchorLine = {};
	public var right:AnchorLine = {};
	public var bottom:AnchorLine = {};
	public var margins:FastFloat = 0.;
	public var topMargin:FastFloat = Math.NaN;
	public var leftMargin:FastFloat = Math.NaN;
	public var rightMargin:FastFloat = Math.NaN;
	public var bottomMargin:FastFloat = Math.NaN;

	public function new() {}

	public inline function set(left:AnchorLine, top:AnchorLine, right:AnchorLine, bottom:AnchorLine) {
		this.top = top;
		this.left = left;
		this.right = right;
		this.bottom = bottom;
	}

	public inline function fill(element:Element):Void {
		set(element.top, element.left, element.right, element.bottom);
	}
}

@:structInit
class AnchorLine {
	public var position:FastFloat = Math.NaN;
}
