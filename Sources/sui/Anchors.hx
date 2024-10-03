package sui;

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
}

@:structInit
class AnchorLine {
	public var position:FastFloat = Math.NaN;
	public var margin:FastFloat = Math.NaN;
}
