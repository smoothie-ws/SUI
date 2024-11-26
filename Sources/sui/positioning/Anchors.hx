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
	@:isVar public var horizontalCenter(default, set):AnchorLine = null;
	@:isVar public var verticalCenter(default, set):AnchorLine = null;
	@:isVar public var margins(default, set):Float = 0;
	@:isVar public var leftMargin(default, set):Float = 0;
	@:isVar public var topMargin(default, set):Float = 0;
	@:isVar public var rightMargin(default, set):Float = 0;
	@:isVar public var bottomMargin(default, set):Float = 0;
	@:isVar public var horizontalCenterOffset(default, set):Float = 0;
	@:isVar public var verticalCenterOffset(default, set):Float = 0;

	public function new(el:Element) {
		_el = el;
	}

	inline function propagate_left(position:Float) {
		_el.x = position + leftMargin;
	}

	inline function propagate_top(position:Float) {
		_el.y = position + topMargin;
	}

	inline function propagate_right(position:Float) {
		_el.width = position - rightMargin - _el.x;
	}

	inline function propagate_bottom(position:Float) {
		_el.height = position - bottomMargin - _el.y;
	}

	inline function propagate_horizontalCenter(position:Float) {
		_el.centerX = position + horizontalCenterOffset;
	}

	inline function propagate_verticalCenter(position:Float) {
		_el.centerY = position + verticalCenterOffset;
	}

	inline function setAnchorLine(anchorLine:AnchorLine, listener:Float->Void, value:AnchorLine) {
		if (value == null && anchorLine != null)
			anchorLine.removePositionListener(listener);
		else
			value.addPositionListener(listener);

		anchorLine = value;
		return value;
	}

	inline function set_left(value:AnchorLine):AnchorLine {
		return setAnchorLine(left, propagate_left, value);
	}

	inline function set_top(value:AnchorLine):AnchorLine {
		return setAnchorLine(top, propagate_top, value);
	}

	inline function set_right(value:AnchorLine):AnchorLine {
		return setAnchorLine(right, propagate_right, value);
	}

	inline function set_bottom(value:AnchorLine):AnchorLine {
		return setAnchorLine(bottom, propagate_bottom, value);
	}

	inline function set_horizontalCenter(value:AnchorLine):AnchorLine {
		return setAnchorLine(horizontalCenter, propagate_horizontalCenter, value);
	}

	inline function set_verticalCenter(value:AnchorLine):AnchorLine {
		return setAnchorLine(verticalCenter, propagate_verticalCenter, value);
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

	inline function set_horizontalCenterOffset(value:Float):Float {
		_el.horizontalCenter.position += value - horizontalCenterOffset;
		horizontalCenterOffset = value;
		return value;
	}

	inline function set_verticalCenterOffset(value:Float):Float {
		_el.verticalCenter.position += value - verticalCenterOffset;
		verticalCenterOffset = value;
		return value;
	}

	public inline function fill(element:Element) {
		left = element.left;
		top = element.top;
		right = element.right;
		bottom = element.bottom;
	}

	public inline function centerIn(element:Element) {
		horizontalCenter = element.horizontalCenter;
		verticalCenter = element.verticalCenter;
	}
}

@:structInit
class AnchorLine {
	@:isVar public var position(default, set):FastFloat = 0;

	var positionListeners:Array<FastFloat->Void> = [];

	inline function set_position(value:FastFloat):FastFloat {
		position = value;
		for (f in positionListeners)
			f(position);
		return value;
	}

	public inline function addPositionListener(f:FastFloat->Void) {
		positionListeners.push(f);
		f(position);
	}

	public inline function removePositionListener(f:FastFloat->Void) {
		positionListeners.remove(f);
	}
}
