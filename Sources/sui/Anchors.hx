package sui;

import kha.FastFloat;
// sui
import sui.elements.Element;

@:structInit
class Anchors {
	// anchors
	public var fill:Element = null;
	public var top:AnchorLine = {};
	public var left:AnchorLine = {};
	public var right:AnchorLine = {};
	public var bottom:AnchorLine = {};
	// center
	public var centerIn:Element = null;
	public var horizontalCenter:FastFloat = 0.;
	public var verticalCenter:FastFloat = 0.;

	public var margins:FastFloat = 0.;
}

@:structInit
class AnchorLine {
	public var position = 0.;
	public var padding = 0.;
	public var margin = null;
}
