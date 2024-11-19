package sui.elements;

import sui.elements.batches.ElementBatch;
import kha.FastFloat;
// sui
import sui.positioning.Anchors;

class Element {
	public function new() {}

	public var batch:ElementBatch;
	public var instanceID:Int;
	public var batchType(get, never):Class<ElementBatch>;

	function get_batchType():Class<ElementBatch> {
		return null;
	}

	// anchors
	public var anchors:Anchors = {};
	@:isVar public var top(get, never):AnchorLine = {_m: 1};
	@:isVar public var left(get, never):AnchorLine = {_m: 1};
	@:isVar public var right(get, never):AnchorLine = {_m: -1};
	@:isVar public var bottom(get, never):AnchorLine = {_m: -1};

	function get_top():AnchorLine {
		return anchors.top.isBinded ? anchors.top : top;
	}

	function get_left():AnchorLine {
		return anchors.left.isBinded ? anchors.left : left;
	}

	function get_right():AnchorLine {
		return anchors.right.isBinded ? anchors.right : right;
	}

	function get_bottom() {
		return anchors.bottom.isBinded ? anchors.bottom : bottom;
	}

	// dimensions
	@:isVar public var x(get, set):FastFloat = 0;
	@:isVar public var y(get, set):FastFloat = 0;
	@:isVar public var width(get, set):FastFloat = 0;
	@:isVar public var height(get, set):FastFloat = 0;

	function get_x():FastFloat {
		return x;
	}

	function set_x(value:FastFloat):FastFloat {
		x = value;
		left.position = x;
		return value;
	}

	function get_y():FastFloat {
		return y;
	}

	function set_y(value:FastFloat):FastFloat {
		y = value;
		top.position = y;
		return value;
	}

	function get_width():FastFloat {
		return width;
	}

	function set_width(value:FastFloat):FastFloat {
		width = value;
		right.position = left.position + width;
		return value;
	}

	function get_height():FastFloat {
		return height;
	}

	function set_height(value:FastFloat):FastFloat {
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

	function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	function get_finalOpacity():FastFloat {
		return parent == null ? opacity : parent.finalOpacity * opacity;
	}

	public function resize(w:Int, h:Int) {
		width = w;
		height = h;
	}

	public function resizeTree(w:Int, h:Int) {
		resize(w, h);
		for (child in children)
			child.resizeTree(w, h);
	}

	public function addChild(child:Element) {
		children.push(child);
		child.parent = this;
	}

	public function removeChild(child:Element) {
		var index = children.indexOf(child);
		if (index != -1) {
			children.splice(index, 1);
			child.parent = null;
		}
	}

	public function removeChildren() {
		for (child in children)
			child.parent = null;

		children = [];
	}

	public function setParent(parent:Element) {
		parent.addChild(this);
	}

	public function removeParent() {
		parent.removeChild(this);
	}

	public function construct() {}

	public function constructTree() {
		construct();
		for (child in children)
			child.constructTree();
	}
}
