package sui;

import kha.FastFloat;
// sui
import sui.elements.Element;

@:structInit
class Anchors {
	// anchors
	public var fill:Element = null;
	public var top:AnchorLine = {value: 0.};
	public var left:AnchorLine = {value: 0.};
	public var right:AnchorLine = {value: 0.};
	public var bottom:AnchorLine = {value: 0.};
	// center
	public var centerIn:Element = null;
	public var horizontalCenter:FastFloat = 0.;
	public var verticalCenter:FastFloat = 0.;
	// margins
	public var margins:FastFloat = 0.;
	public var leftMargin:FastFloat = null;
	public var topMargin:FastFloat = null;
	public var rightMargin:FastFloat = null;
	public var bottomMargin:FastFloat = null;
}

@:structInit
class AnchorLine {
	public var value = 0.;
}
