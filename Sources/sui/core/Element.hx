package sui.core;

import kha.Color;
import kha.FastFloat;
// sui
import sui.transform.Transform;
import sui.core.utils.Math.clamp;
import sui.core.layouts.Anchors;

@:structInit
class Element {
	// position
	public var x:FastFloat = 0.;
	public var y:FastFloat = 0.;
	// dimensions
	public var width:FastFloat = 0.;
	public var height:FastFloat = 0.;
	public var minWidth:FastFloat = Math.NEGATIVE_INFINITY;
	public var maxWidth:FastFloat = Math.POSITIVE_INFINITY;
	public var minHeight:FastFloat = Math.NEGATIVE_INFINITY;
	public var maxHeight:FastFloat = Math.POSITIVE_INFINITY;
	// transform
	public var transform:Transform = {};
	public var scale:FastFloat = Math.NaN;
	// opacity
	public var opacity:FastFloat = 1.;
	// relations
	public var parent:Element = null;
	public var children:Array<Element> = [];
	// flags
	public var visible:Bool = true;
	public var enabled:Bool = true;
	public var clip:Bool = true;
	// anchors
	public var anchors:Anchors = {};
	// color
	public var color:Color = Color.White;

	// final transform
	public var finalX(get, never):FastFloat;
	public var finalY(get, never):FastFloat;
	public var finalW(get, never):FastFloat;
	public var finalH(get, never):FastFloat;
	public var finalBounds(get, never):Array<FastFloat>;
	public var finalScaleX(get, never):FastFloat;
	public var finalScaleY(get, never):FastFloat;
	public var finalEnabled(get, never):Bool;
	public var finalOpacity(get, never):FastFloat;
	public var finalRotation(get, never):FastFloat;

	inline function get_finalScaleX():FastFloat {
		var scale = Math.isNaN(transform.scale.x) ? scale : transform.scale.x;
		var parentScale = parent == null ? 1 : parent.finalScaleX;
		return scale * parentScale;
	}

	inline function get_finalScaleY():FastFloat {
		var scale = Math.isNaN(transform.scale.y) ? scale : transform.scale.y;
		var parentScale = parent == null ? 1 : parent.finalScaleY;
		return scale * parentScale;
	}

	inline function get_finalX():FastFloat {
		var _fill = anchors.fill;
		var oX = parent == null ? 0 : parent.finalX;
		if (_fill == null)
			oX = Math.isNaN(anchors.left.position) ? x : anchors.left.position;
		else
			oX = Math.isNaN(anchors.left.position) ? _fill.finalX : anchors.left.position;
		oX += Math.isNaN(anchors.left.margin) ? anchors.margins : anchors.left.margin;
		return oX + transform.translate.x;
	}

	inline function get_finalY():FastFloat {
		var _fill = anchors.fill;
		var oY = parent == null ? 0 : parent.finalY;
		if (_fill == null)
			oY = Math.isNaN(anchors.top.position) ? y : anchors.top.position;
		else
			oY = Math.isNaN(anchors.top.position) ? _fill.finalY : anchors.top.position;
		oY += Math.isNaN(anchors.top.margin) ? anchors.margins : anchors.top.margin;
		return oY + transform.translate.y;
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

	inline function get_finalBounds():Array<FastFloat> {
		return [
			(finalX + finalW / 2) / SUI.backbuffer.width * 2 - 1,
			(finalY + finalH / 2) / SUI.backbuffer.width * 2 - 1,
			finalW,
			finalH
		];
	}

	inline function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	inline function get_finalOpacity():FastFloat {
		return parent == null ? opacity : parent.finalOpacity * opacity;
	}

	inline function get_finalRotation():FastFloat {
		var rotation = transform.rotation.angle;
		var parentRotation = parent == null ? 0 : parent.finalRotation;
		return rotation + parentRotation;
	}

	function resize(w:Int, h:Int) {}

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
}
