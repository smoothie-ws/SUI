package sui.elements;

import kha.FastFloat;
import kha.math.FastVector4;
// sui
import sui.layouts.Anchors;
import sui.core.utils.Math.clamp;

@:structInit
class Element {
	// position
	public var x:FastFloat = 0;
	public var y:FastFloat = 0;
	// dimensions
	public var width:FastFloat = 0;
	public var height:FastFloat = 0;
	public var minWidth:FastFloat = Math.NEGATIVE_INFINITY;
	public var maxWidth:FastFloat = Math.POSITIVE_INFINITY;
	public var minHeight:FastFloat = Math.NEGATIVE_INFINITY;
	public var maxHeight:FastFloat = Math.POSITIVE_INFINITY;
	// opacity
	public var opacity:FastFloat = 1;
	// relations
	public var parent:Element = null;
	public var children:Array<Element> = [];
	// flags
	public var visible:Bool = true;
	public var enabled:Bool = true;
	public var clip:Bool = true;
	// anchors
	public var anchors:Anchors = {};
	@:isVar public var left(get, never):AnchorLine = {};
	@:isVar public var top(get, never):AnchorLine = {};
	@:isVar public var right(get, never):AnchorLine = {};
	@:isVar public var bottom(get, never):AnchorLine = {};
	@:isVar public var horizontalCenter(get, never):AnchorLine = {};
	@:isVar public var verticalCenter(get, never):AnchorLine = {};

	// final transform
	public var finalEnabled(get, never):Bool;
	public var finalOpacity(get, never):FastFloat;

	inline function get_left():AnchorLine {
		if (anchors.fill != null)
			left.position = anchors.fill.left.position;
		else
			left.position = Math.isNaN(anchors.left.position) ? x : anchors.left.position;
		left.position += Math.isNaN(anchors.leftMargin) ? anchors.margins : anchors.leftMargin;
		return left;
	}

	inline function get_top():AnchorLine {
		if (anchors.fill != null)
			top.position = anchors.fill.top.position;
		else
			top.position = Math.isNaN(anchors.top.position) ? x : anchors.top.position;
		top.position += Math.isNaN(anchors.topMargin) ? anchors.margins : anchors.topMargin;
		return top;
	}

	inline function get_right():AnchorLine {
		if (anchors.fill != null)
			right.position = anchors.fill.right.position;
		else
			right.position = Math.isNaN(anchors.right.position) ? width : anchors.right.position;
		right.position -= Math.isNaN(anchors.rightMargin) ? anchors.margins : anchors.rightMargin;
		right.position = clamp(right.position, minWidth, maxWidth);
		return right;
	}

	inline function get_bottom():AnchorLine {
		if (anchors.fill != null)
			bottom.position = anchors.fill.bottom.position;
		else
			bottom.position = Math.isNaN(anchors.bottom.position) ? height : anchors.bottom.position;
		bottom.position -= Math.isNaN(anchors.bottomMargin) ? anchors.margins : anchors.bottomMargin;
		bottom.position = clamp(bottom.position, minHeight, maxHeight);
		return bottom;
	}

	inline function get_horizontalCenter():AnchorLine {
		horizontalCenter.position = (left.position + right.position) / 2;
		return horizontalCenter;
	}

	inline function get_verticalCenter():AnchorLine {
		verticalCenter.position = (top.position + bottom.position) / 2;
		return verticalCenter;
	}

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
