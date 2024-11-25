package sui.positioning;

import kha.FastFloat;
// sui
import sui.elements.Element;

class Anchors {
	var _el:Element;

	@:isVar public var left(default, set):AnchorLine = null;
	@:isVar public var top(default, set):AnchorLine = null;
	@:isVar public var right(default, set):AnchorLine = null;
	@:isVar public var bottom(default, set):AnchorLine = null;
	@:isVar public var margins(default, set):Float = 0;
	@:isVar public var leftMargin(default, set):Float = 0;
	@:isVar public var topMargin(default, set):Float = 0;
	@:isVar public var rightMargin(default, set):Float = 0;
	@:isVar public var bottomMargin(default, set):Float = 0;

	public function new(el:Element) {
		_el = el;
	}

	inline function propagate_left(position:Float) {
		_el.left.position = position + leftMargin;
	}

	inline function propagate_top(position:Float) {
		_el.top.position = position + topMargin;
	}

	inline function propagate_right(position:Float) {
		_el.right.position = position - rightMargin;
	}

	inline function propagate_bottom(position:Float) {
		_el.bottom.position = position - bottomMargin;
	}

	inline function set_left(value:AnchorLine):AnchorLine {
		if (value == null && left != null)
			left.listeners.remove(propagate_left);
		else
			value.addListener(propagate_left);

		left = value;
		return value;
	}

	inline function set_top(value:AnchorLine):AnchorLine {
		if (value == null && top != null)
			top.listeners.remove(propagate_top);
		else
			value.addListener(propagate_top);

		top = value;
		return value;
	}

	inline function set_right(value:AnchorLine):AnchorLine {
		if (value == null && right != null)
			right.listeners.remove(propagate_right);
		else
			value.addListener(propagate_right);

		right = value;
		return value;
	}

	inline function set_bottom(value:AnchorLine):AnchorLine {
		if (value == null && bottom != null)
			bottom.listeners.remove(propagate_bottom);
		else
			value.addListener(propagate_bottom);

		bottom = value;
		return value;
	}

	inline function set_margins(value:Float) {
		margins = value;
		leftMargin = value;
		topMargin = value;
		rightMargin = value;
		bottomMargin = value;
		return value;
	}

	inline function set_leftMargin(value:Float):Float {
		_el.left.position += value - leftMargin;
		leftMargin = value;
		return value;
	}

	inline function set_topMargin(value:Float):Float {
		_el.top.position += value - topMargin;
		topMargin = value;
		return value;
	}

	inline function set_rightMargin(value:Float):Float {
		_el.right.position -= value - rightMargin;
		rightMargin = value;
		return value;
	}

	inline function set_bottomMargin(value:Float):Float {
		_el.bottom.position -= value - bottomMargin;
		bottomMargin = value;
		return value;
	}

	public inline function fill(element:Element) {
		left = element.left;
		top = element.top;
		right = element.right;
		bottom = element.bottom;
	}
}

@:structInit
class AnchorLine {
	@:allow(sui.positioning.Anchors)
	var listeners:Array<FastFloat->Void> = [];

	public var position(default, set):FastFloat = 0;

	public inline function addListener(f:FastFloat->Void) {
		listeners.push(f);
		f(position);
	}

	public inline function removeListener(f:FastFloat->Void) {
		listeners.remove(f);
	}

	inline function set_position(value:FastFloat):FastFloat {
		position = value;
		for (f in listeners)
			f(position);
		return position;
	}
}
