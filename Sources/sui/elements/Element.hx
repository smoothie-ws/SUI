package sui.elements;

import kha.math.FastMatrix3;
import kha.math.FastMatrix3;
import kha.FastFloat;
// sui
import sui.Color;

@:structInit
class Element {
	// position
	public var x:FastFloat = 0.;
	public var y:FastFloat = 0.;
	// dimensions
	public var width:FastFloat = 0.;
	public var height:FastFloat = 0.;
	// scale
	public var scaleX:FastFloat = 1.;
	public var scaleY:FastFloat = 1.;
	// rotation
	public var rotation:FastFloat = 0.;
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
	public var color:Color = Color.white;

	// final transformation
	var finalOpacity(get, never):FastFloat;
	var finalEnabled(get, never):Bool;
	var offsetX(get, never):FastFloat;
	var offsetY(get, never):FastFloat;
	var finalW(get, never):FastFloat;
	var finalH(get, never):FastFloat;

	inline function get_finalOpacity():FastFloat {
		return parent == null ? opacity : parent.finalOpacity * opacity;
	}

	inline function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	inline function get_offsetX():FastFloat {
		var itemToFill = anchors.fill;
		var oX = 0.;
		if (itemToFill == null)
			oX = Math.isNaN(anchors.left.position) ? 0. : anchors.left.position;
		else
			oX = itemToFill.offsetX;
		oX += Math.isNaN(anchors.left.margin) ? anchors.margins : anchors.left.margin;
		return oX;
	}

	inline function get_finalY():FastFloat {
		var baseY = anchors.top.position + anchors.top.padding + y;

		baseY += anchors.top.margin != Math.NaN ? anchors.top.margin : anchors.margins;
		return baseY;
	inline function get_offsetY():FastFloat {
		var itemToFill = anchors.fill;
		var oY = 0.;
		if (itemToFill == null)
			oY = Math.isNaN(anchors.top.position) ? 0. : anchors.top.position;
		else
			oY = itemToFill.offsetY;
		oY += Math.isNaN(anchors.top.margin) ? anchors.margins : anchors.top.margin;
		return oY;
	}

	inline function get_finalW():FastFloat {
		var baseW = anchors.right.position - anchors.right.padding + width;

		baseW -= anchors.right.margin != Math.NaN ? anchors.right.margin : anchors.margins;
		return baseW;
		var itemToFill = anchors.fill;
		var fW = 0.;
		if (itemToFill == null)
			fW = Math.isNaN(anchors.right.position) ? width : anchors.right.position;
		else
			fW = itemToFill.finalW;
		fW -= Math.isNaN(anchors.left.margin) ? anchors.margins : anchors.left.margin;
		fW -= Math.isNaN(anchors.right.margin) ? anchors.margins : anchors.right.margin;
		return fW;
	}

	inline function get_finalH():FastFloat {
		var itemToFill = anchors.fill;
		var fH = 0.;
		if (itemToFill == null)
			fH = Math.isNaN(anchors.bottom.position) ? width : anchors.bottom.position;
		else
			fH = itemToFill.finalH;
		fH -= Math.isNaN(anchors.top.margin) ? anchors.margins : anchors.top.margin;
		fH -= Math.isNaN(anchors.bottom.margin) ? anchors.margins : anchors.bottom.margin;
		return fH;
	}

	public function draw() {}

	public function drawTree() {
		if (!visible)
			return;

		SUI.graphics.color = kha.Color.fromValue(color);
		SUI.graphics.opacity = finalOpacity;
		SUI.graphics.pushRotation(rotation, 0, 0);
		SUI.graphics.pushScale(scaleX, scaleY);

		SUI.graphics.translate(offsetX, offsetY);
		draw();
		SUI.graphics.translate(-offsetX, -offsetY);
		for (child in children)
			child.drawTree();

		SUI.graphics.pushScale(1 / scaleX, 1 / scaleY);
		SUI.graphics.pushRotation(-rotation, 0, 0);
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
		for (child in children) {
			child.parent = null;
		}
		children = [];
	}

	public inline final function setParent(parent:Element) {
		parent.addChild(this);
	}

	public inline final function removeParent() {
		parent.removeChild(this);
	}
}
