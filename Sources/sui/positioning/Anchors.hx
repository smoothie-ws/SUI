package sui.positioning;

import kha.FastFloat;
// sui
import sui.elements.Element;

@:structInit
class Anchors {
	public var top:AnchorLine = {_m: 1};
	public var left:AnchorLine = {_m: 1};
	public var right:AnchorLine = {_m: -1};
	public var bottom:AnchorLine = {_m: -1};
	@:isVar public var margins(get, set):FastFloat = 0;
	@:isVar public var padding(get, set):FastFloat = 0;

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

	public inline function get_padding() {
		return padding;
	}

	public inline function set_padding(value:FastFloat) {
		padding = value;
		top.padding = value;
		left.padding = value;
		right.padding = value;
		bottom.padding = value;
		return value;
	}

	public inline function fill(element:Element) {
		top.bindTo(element.top);
		left.bindTo(element.left);
		right.bindTo(element.right);
		bottom.bindTo(element.bottom);
	}
}

@:structInit
class AnchorLine {
	public var isBinded:Bool = false;

	var _p:AnchorLine = null;
	var _m:Int;
	var _C:Array<AnchorLine> = [];

	@:isVar public var margin(get, set):FastFloat = 0;
	@:isVar public var padding(get, set):FastFloat = 0;
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

	inline function get_padding():FastFloat {
		return padding;
	}

	inline function set_padding(value:FastFloat):FastFloat {
		padding = value;
		for (c in _C)
			c.position += value - padding * _m;
		return value;
	}

	inline function get_position():FastFloat {
		return position + margin * _m;
	}

	inline function set_position(value:FastFloat):FastFloat {
		position = value;
		for (c in _C)
			c.position = position + padding * _m;
		return value;
	}

	public inline function bindTo(p:AnchorLine) {
		isBinded = true;
		position = p.position;
		p._C.push(this);
		_p = p;
	}

	public inline function unbind(c:AnchorLine) {
		isBinded = false;
		_p._C.remove(c);
		_p = null;
	}
}
