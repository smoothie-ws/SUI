package sui.elements;

import kha.FastFloat;
// sui
import sui.positioning.Anchors;
import sui.core.utils.Math.clamp;

class Element {
	public function new() {}

	// anchors
	public var anchors:Anchors = {};
	@:isVar public var top(get, never):AnchorLine = {_m: 1};
	@:isVar public var left(get, never):AnchorLine = {_m: 1};
	@:isVar public var right(get, never):AnchorLine = {_m: -1};
	@:isVar public var bottom(get, never):AnchorLine = {_m: -1};

	inline function get_top():AnchorLine {
		return anchors.top.isBinded ? anchors.top : top;
	}

	inline function get_left():AnchorLine {
		return anchors.left.isBinded ? anchors.left : left;
	}

	inline function get_right():AnchorLine {
		return anchors.right.isBinded ? anchors.right : right;
	}

	inline function get_bottom() {
		return anchors.bottom.isBinded ? anchors.bottom : bottom;
	}

	// dimensions
	@:isVar public var x(get, set):FastFloat;
	@:isVar public var y(get, set):FastFloat;
	@:isVar public var width(get, set):FastFloat;
	@:isVar public var height(get, set):FastFloat;

	inline function get_x():FastFloat {
		return x;
	}

	inline function set_x(value:FastFloat):FastFloat {
		x = value;
		left.position = x;
		return value;
	}

	inline function get_y():FastFloat {
		return y;
	}

	inline function set_y(value:FastFloat):FastFloat {
		y = value;
		top.position = y;
		return value;
	}

	inline function get_width():FastFloat {
		return width;
	}

	inline function set_width(value:FastFloat):FastFloat {
		width = value;
		right.position = left.position + width;
		return value;
	}

	inline function get_height():FastFloat {
		return height;
	}

	inline function set_height(value:FastFloat):FastFloat {
		height = value;
		bottom.position = top.position + height;
		return value;
	}

	public var opacity:FastFloat = 1;
	public var parent:Element = null;
	public var children:Array<Element> = [];
	public var visible:Bool = true;
	public var enabled:Bool = true;
	public var clip:Bool = true;

	public var finalEnabled(get, never):Bool;
	public var finalOpacity(get, never):FastFloat;

	inline function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	inline function get_finalOpacity():FastFloat {
		return parent == null ? opacity : parent.finalOpacity * opacity;
	}

	public function resize(w:Int, h:Int) {
		width = w;
		height = h;
	}

	public inline final function resizeTree(w:Int, h:Int) {
		resize(w, h);
		for (child in children)
			child.resizeTree(w, h);
	}

	public inline final function addChild(child:Element) {
		children.push(child);
		child.parent = this;
	}

	public inline final function removeChild(child:Element) {
		var index = children.indexOf(child);
		if (index != -1) {
			children.splice(index, 1);
			child.parent = null;
		}
	}

	public inline final function removeChildren() {
		for (child in children)
			child.parent = null;

		children = [];
	}

	public inline final function setParent(parent:Element) {
		parent.addChild(this);
	}

	public inline final function removeParent() {
		parent.removeChild(this);
	}

	public function construct() {}

	public inline final function constructTree() {
		construct();
		for (child in children)
			child.constructTree();
	}
}
