package sui.elements;

import kha.math.FastVector4;
import kha.FastFloat;
import kha.math.FastVector2;
// sui
import sui.positioning.Anchors;
import sui.elements.batches.ElementBatch;

class Element {
	public var batch:ElementBatch;
	public var instanceID:Int;
	public var batchType(get, never):Class<ElementBatch>;

	function get_batchType():Class<ElementBatch> {
		return null;
	}

	public function new() {
		anchors = new Anchors(this);
	}

	// anchors
	public var anchors:Anchors;
	@:isVar public var left(default, never):AnchorLine = {};
	@:isVar public var top(default, never):AnchorLine = {};
	@:isVar public var right(default, never):AnchorLine = {};
	@:isVar public var bottom(default, never):AnchorLine = {};

	// positioning
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;

	function set_x(value:Float):Float {
		right.position += value - left.position;
		left.position = value;
		return value;
	}

	function get_x():Float {
		return left.position;
	}

	function set_y(value:Float):Float {
		bottom.position += value - top.position;
		top.position = value;
		return value;
	}

	function get_y():Float {
		return top.position;
	}

	function get_width():Float {
		return right.position - left.position;
	}

	function set_width(value:Float):Float {
		right.position = left.position + value;
		return value;
	}

	function get_height():Float {
		return bottom.position - top.position;
	}

	function set_height(value:Float):Float {
		bottom.position = top.position + value;
		return value;
	}

	// transformation
	public var origin:FastVector2 = {};
	public var scale:FastVector2 = {x: 1, y: 1};
	public var rotation:FastFloat = 0;
	public var translation:FastVector2 = {};

	public var opacity:FastFloat = 1;
	public var parent:Element = null;
	public var children:Array<Element> = [];
	public var visible:Bool = true;
	public var enabled:Bool = true;

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
