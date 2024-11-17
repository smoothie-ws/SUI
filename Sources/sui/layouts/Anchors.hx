package sui.layouts;

import kha.FastFloat;
// sui
import sui.elements.Element;

@:structInit
class Anchors {
	public var fill:Element = null;
	public var top:AnchorLine = {};
	public var left:AnchorLine = {};
	public var right:AnchorLine = {};
	public var bottom:AnchorLine = {};
	public var margins:FastFloat = 0.;
	public var topMargin:FastFloat = Math.NaN;
	public var leftMargin:FastFloat = Math.NaN;
	public var rightMargin:FastFloat = Math.NaN;
	public var bottomMargin:FastFloat = Math.NaN;
}

@:structInit
class AnchorLine {
	public var position:FastFloat = Math.NaN;
}
