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
		
		propagateLeft = {
			ID: 0,
			f: _propagateLeft
		};
		propagateTop = {
			ID: 0,
			f: _propagateLeft
		};

		propagateRight = {
			ID: 0,
			f: _propagateLeft
		};

		propagateBottom = {
			ID: 0,
			f: _propagateLeft
		};
		propagateHorizontalCenter = {
			ID: 0,
			f: _propagateLeft
		};

		propagateVerticalCenter = {
			ID: 0,
			f: _propagateLeft
		};
	}

	inline function _propagateLeft(position:Float) {
		_el.x = position + leftMargin;
	}

	inline function _propagateTop(position:Float) {
		_el.y = position + topMargin;
	}

	inline function _propagateRight(position:Float) {
		_el.width = position - rightMargin - _el.x;
	}

	inline function _propagateBottom(position:Float) {
		_el.height = position - bottomMargin - _el.y;
	}

	inline function _propagateHorizontalCenter(position:Float) {
		_el.centerX = position + horizontalCenterOffset;
	}

	inline function _propagateVerticalCenter(position:Float) {
		_el.centerY = position + verticalCenterOffset;
	}

	var propagateLeft:AnchorLineListener;
	var propagateTop:AnchorLineListener;
	var propagateRight:AnchorLineListener;
	var propagateBottom:AnchorLineListener;
	var propagateHorizontalCenter:AnchorLineListener;
	var propagateVerticalCenter:AnchorLineListener;

	inline function setAnchorLine(anchorLine:AnchorLine, listener:AnchorLineListener, value:AnchorLine) {
		if (value == null && anchorLine != null)
			anchorLine.removePositionListener(listener.ID);
		else
			listener.ID = value.addPositionListener(listener.f);

		anchorLine = value;
		return value;
	}

	inline function set_left(value:AnchorLine):AnchorLine {
		return setAnchorLine(left, propagateLeft, value);
	}

	inline function set_top(value:AnchorLine):AnchorLine {
		return setAnchorLine(top, propagateTop, value);
	}

	inline function set_right(value:AnchorLine):AnchorLine {
		return setAnchorLine(right, propagateRight, value);
	}

	inline function set_bottom(value:AnchorLine):AnchorLine {
		return setAnchorLine(bottom, propagateBottom, value);
	}

	inline function set_horizontalCenter(value:AnchorLine):AnchorLine {
		return setAnchorLine(horizontalCenter, propagateHorizontalCenter, value);
	}

	inline function set_verticalCenter(value:AnchorLine):AnchorLine {
		return setAnchorLine(verticalCenter, propagateVerticalCenter, value);
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
@:build(sui.core.macro.SUIMacro.build())
class AnchorLine {
	@observable public var position:FastFloat = 0;
}

private typedef AnchorLineListener = {
	public var ID:Int;
	public var f:FastFloat->Void;
}
