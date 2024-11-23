package sui.positioning;

import kha.FastFloat;
// sui
import sui.elements.Element;

@:structInit
class Anchors {
	var _el:Element;

	public inline function new(element:Element) {
		_el = element;
	}

	@:isVar public var top(get, set):AnchorLine = {
		_m: 1
	};
	@:isVar public var left(get, set):AnchorLine = {
		_m: 1
	};
	@:isVar public var right(get, set):AnchorLine = {
		_m: -1
	};
	@:isVar public var bottom(get, set):AnchorLine = {
		_m: -1
	};
	@:isVar public var margins(get, set):FastFloat = 0;

	inline function get_top() {
		return top;
	}

	inline function set_top(value:AnchorLine) {
		top.bindTo(value);
		return value;
	}

	inline function get_left() {
		return left;
	}

	inline function set_left(value:AnchorLine) {
		left.bindTo(value);
		return value;
	}

	inline function get_right() {
		return right;
	}

	inline function set_right(value:AnchorLine) {
		right.bindTo(value);
		return value;
	}

	inline function get_bottom() {
		return bottom;
	}

	inline function set_bottom(value:AnchorLine) {
		bottom.bindTo(value);
		return value;
	}

	public inline function get_margins() {
		return margins;
	}

	public inline function set_margins(value:FastFloat) {
		margins = value;
		top.margin = value;
		left.margin = value;
		right.margin = value;
		bottom.margin = value;
		return value;
	}

	public inline function fill(element:Element) {
		top = element.anchors.top;
		left = element.anchors.left;
		right = element.anchors.right;
		bottom = element.anchors.bottom;
	}
}

@:structInit
class AnchorLine {
	var _p:AnchorLine = null;
	var _m:Int;
	var _C:Array<AnchorLine> = [];

	@:isVar public var margin(get, set):FastFloat = 0;
	@:isVar public var position(get, set):FastFloat = 0;

	inline function get_margin():FastFloat {
		return margin;
	}

	inline function set_margin(value:FastFloat):FastFloat {
		for (c in _C)
			c.position += (value - margin) * _m;
		margin = value;
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

	public inline function bindTo(p:AnchorLine) {
		p.bind(this);
	}

	public inline function bind(c:AnchorLine) {
		c.position = position;
		c._p = this;
		_C.push(c);
	}

	public inline function unbind() {
		if (_p != null)
			_p._C.remove(this);
		_p = null;
	}
}
