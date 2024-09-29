package sui.elements;

import kha.FastFloat;

@:structInit
class Element {
	// position
	public var x:FastFloat = 0.;
	public var y:FastFloat = 0.;
	public var z:Int = 0;
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
	// box
	public var anchors:Sides = null;
	public var padding:Sides = null;
	public var margin:Sides = null;
	public var border:Sides = null;

	// final transform
	public var finalRotation(get, never):FastFloat;
	public var finalOpacity(get, never):FastFloat;
	public var finalEnabled(get, never):Bool;
	public var finalX(get, never):FastFloat;
	public var finalY(get, never):FastFloat;
	public var finalZ(get, never):Int;
	public var finalW(get, never):FastFloat;
	public var finalH(get, never):FastFloat;

	function get_finalRotation():FastFloat {
		return parent != null ? parent.finalRotation + rotation : rotation;
	}

	function get_finalOpacity():FastFloat {
		return parent != null ? parent.finalOpacity * opacity : opacity;
	}

	function get_finalEnabled():Bool {
		return parent != null ? parent.finalEnabled && enabled : enabled;
	}

	public inline final function get_finalX():FastFloat {
		return parent != null ? parent.get_finalX() + x : x;
	}

	public inline final function get_finalY():FastFloat {
		return parent != null ? parent.get_finalY() + y : y;
	}

	public inline final function get_finalZ():Int {
		return parent != null ? parent.get_finalZ() + z : z;
	}

	public inline final function get_finalW():FastFloat {
		return parent != null ? parent.scaleX * scaleX * width : scaleX * width;
	}

	public inline final function get_finalH():FastFloat {
		return parent != null ? parent.scaleY * scaleY * height : scaleY * height;
	}

	public inline final function applyTransformation() {
		SUI.graphics.opacity = finalOpacity;
		SUI.graphics.pushRotation(finalRotation, finalX, finalY);
		SUI.graphics.pushScale(scaleX, scaleY);
	}

	public inline final function popTransformation() {
		SUI.graphics.popTransformation();
	}

	function draw() {}

	public function drawAll() {
		if (!visible)
			return;

		draw();
		for (child in children) {
			child.drawAll();
		}
	}

	public final function addChild(child:Element) {
		children.push(child);
		child.parent = this;
	}

	public final function removeChild(child:Element) {
		var index = children.indexOf(child);
		if (index != -1) {
			children.splice(index, 1);
			child.parent = null;
		}
	}

	public final function removeChildren() {
		for (child in children) {
			child.parent = null;
		}
		children = [];
	}

	public final function setParent(parent:Element) {
		parent.addChild(this);
	}

	public final function removeParent() {
		parent.removeChild(this);
	}

	public final function setAnchors(top:Float, right:Float, bottom:Float, left:Float) {
		anchors = {
			top: top,
			right: right,
			bottom: bottom,
			left: left
		};
	}

	public final function setPadding(top:Float, right:Float, bottom:Float, left:Float) {
		padding = {
			top: top,
			right: right,
			bottom: bottom,
			left: left
		};
	}

	public final function setMargin(top:Float, right:Float, bottom:Float, left:Float) {
		margin = {
			top: top,
			right: right,
			bottom: bottom,
			left: left
		};
	}

	public final function setBorder(top:Float, right:Float, bottom:Float, left:Float) {
		border = {
			top: top,
			right: right,
			bottom: bottom,
			left: left
		};
	}
}

typedef Sides = {
	var top:Float;
	var right:Float;
	var bottom:Float;
	var left:Float;
};
