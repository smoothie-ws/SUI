package sui.elements;

import kha.math.FastVector2;
import kha.Color;
import kha.FastFloat;
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
	// transform
	public var origin:FastVector2 = {};
	public var scale:FastVector2 = {x: 1, y: 1};
	public var rotation:FastFloat = 0;
	public var translation:FastVector2 = {};
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

	// final transform
	public var finalX(get, never):FastFloat;
	public var finalY(get, never):FastFloat;
	public var finalW(get, never):FastFloat;
	public var finalH(get, never):FastFloat;
	public var centerX(get, never):FastFloat;
	public var centerY(get, never):FastFloat;
	public var finalScale(get, never):FastVector2;
	public var finalEnabled(get, never):Bool;
	public var finalOpacity(get, never):FastFloat;
	public var finalRotation(get, never):FastFloat;

	inline function get_centerX():FastFloat {
		return finalX + finalW / 2;
	}

	inline function get_centerY():FastFloat {
		return finalY + finalH / 2;
	}

	inline function get_finalScale():FastVector2 {
		return {x: scale.x * parent.finalScale.x, y: scale.y * parent.finalScale.y};
	}

	inline function get_finalX():FastFloat {
		var _fill = anchors.fill;
		var oX = parent == null ? 0 : parent.finalX;
		if (_fill == null)
			oX = Math.isNaN(anchors.left.position) ? x : anchors.left.position;
		else
			oX = Math.isNaN(anchors.left.position) ? _fill.finalX : anchors.left.position;
		oX += Math.isNaN(anchors.left.margin) ? anchors.margins : anchors.left.margin;
		return oX + translation.x;
	}

	inline function get_finalY():FastFloat {
		var _fill = anchors.fill;
		var oY = parent == null ? 0 : parent.finalY;
		if (_fill == null)
			oY = Math.isNaN(anchors.top.position) ? y : anchors.top.position;
		else
			oY = Math.isNaN(anchors.top.position) ? _fill.finalY : anchors.top.position;
		oY += Math.isNaN(anchors.top.margin) ? anchors.margins : anchors.top.margin;
		return oY + translation.y;
	}

	inline function get_finalW():FastFloat {
		var _fill = anchors.fill;
		var fW = 0.;
		if (_fill == null)
			fW = Math.isNaN(anchors.right.position) ? width : anchors.right.position;
		else
			fW = Math.isNaN(anchors.right.position) ? _fill.finalW : anchors.right.position;
		fW -= Math.isNaN(anchors.left.margin) ? anchors.margins : anchors.left.margin;
		fW -= Math.isNaN(anchors.right.margin) ? anchors.margins : anchors.right.margin;
		return clamp(fW, minWidth, maxWidth);
	}

	inline function get_finalH():FastFloat {
		var _fill = anchors.fill;
		var fH = 0.;
		if (_fill == null)
			fH = Math.isNaN(anchors.bottom.position) ? height : anchors.bottom.position;
		else
			fH = Math.isNaN(anchors.bottom.position) ? _fill.finalH : anchors.bottom.position;
		fH -= Math.isNaN(anchors.top.margin) ? anchors.margins : anchors.top.margin;
		fH -= Math.isNaN(anchors.bottom.margin) ? anchors.margins : anchors.bottom.margin;
		return clamp(fH, minHeight, maxHeight);
	}

	inline function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	inline function get_finalOpacity():FastFloat {
		return parent == null ? opacity : parent.finalOpacity * opacity;
	}

	inline function get_finalRotation():FastFloat {
		return rotation + parent.finalRotation;
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
