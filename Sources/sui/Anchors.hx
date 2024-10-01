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
	public var leftMargin:FastFloat = 0.;
	public var topMargin:FastFloat = 0.;
	public var rightMargin:FastFloat = 0.;
	public var bottomMargin:FastFloat = 0.;
	// padding
	public var leftPadding:FastFloat = 0.;
	public var topPadding:FastFloat = 0.;
	public var rightPadding:FastFloat = 0.;
	public var bottomPadding:FastFloat = 0.;

	@:isVar public var margins(get, set):FastFloat = 0.;
	@:isVar public var padding(get, set):FastFloat = 0.;

	inline function get_margins():FastFloat {
		return margins;
	}

	inline function set_margins(value:FastFloat):FastFloat {
		leftMargin = value;
		topMargin = value;
		rightMargin = value;
		bottomMargin = value;
		return value;
	}

	inline function get_padding():FastFloat {
		return padding;
	}

	inline function set_padding(value:FastFloat):FastFloat {
		leftPadding = value;
		topPadding = value;
		rightPadding = value;
		bottomPadding = value;
		return value;
	}
}

@:structInit
class AnchorLine {
	public var value = 0.;
}
