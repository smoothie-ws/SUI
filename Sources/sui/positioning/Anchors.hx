package sui.positioning;

import kha.FastFloat;
// sui
import sui.elements.Element;

@:structInit
class Anchors {
	@:isVar public var top(get, set):AnchorLine = {_m: 1};
	@:isVar public var left(get, set):AnchorLine = {_m: 1};
	@:isVar public var right(get, set):AnchorLine = {_m: -1};
	@:isVar public var bottom(get, set):AnchorLine = {_m: -1};
	@:isVar public var margins(get, set):Float = 0;

	inline function get_top() {
		return top;
	}

	inline function set_top(value:AnchorLine) {
		value.bind(top);
		return value;
	}

	inline function get_left() {
		return left;
	}

	inline function set_left(value:AnchorLine) {
		value.bind(left);
		return value;
	}

	inline function get_right() {
		return right;
	}

	inline function set_right(value:AnchorLine) {
		value.bind(right);
		return value;
	}

	inline function get_bottom() {
		return bottom;
	}

	inline function set_bottom(value:AnchorLine) {
		value.bind(bottom);
		return value;
	}

	public inline function get_margins() {
		return margins;
	}

	public inline function set_margins(value:Float) {
		margins = value;
		top.margin = value;
		left.margin = value;
		right.margin = value;
		bottom.margin = value;
		return value;
	}

	public inline function fill(element:Element) {
		top = element.top;
		left = element.left;
		right = element.right;
		bottom = element.bottom;
	}
}

@:structInit
class AnchorLine {
	public var isBinded:Bool = false;

	var _m:Int;
	var _C:Array<AnchorLine> = [];

	@:isVar public var margin(get, set):FastFloat = 0;
	@:isVar public var position(get, set):FastFloat = 0;

	inline function get_margin():FastFloat {
		return margin;
	}

	inline function set_margin(value:FastFloat):FastFloat {
		margin = value;
		for (c in _C)
			c.position += value - margin * _m;
		return value;
	}

	inline function get_position():FastFloat {
		return position + margin * _m;
	}

	inline function set_position(value:FastFloat):FastFloat {
		position = value;
		for (c in _C)
			c.position = position;
		return value;
	}

	public inline function bind(c:AnchorLine) {
		c.isBinded = true;
		_C.push(c);
	}

	public inline function unBind(c:AnchorLine) {
		c.isBinded = false;
		_C.remove(c);
	}
}
