package sui;

import kha.FastFloat;

class Element {
	// position
	public var x:FastFloat;
	public var y:FastFloat;
	public var z:Int;
	// dimensions
	public var width:FastFloat;
	public var height:FastFloat;
	// scale
	public var scaleX:FastFloat;
	public var scaleY:FastFloat;
	// rotation
	public var rotation:FastFloat;
	// opacity
	public var opacity:FastFloat;
	// relations
	public var parent:Element;
	public var children:Array<Element>;
	// flags
	public var visible:Bool;
	public var enabled:Bool;
	public var clip:Bool;
	// box
	public var anchors:Sides;
	public var padding:Sides;
	public var margin:Sides;
	public var border:Sides;

	// final transform
	public var finalOpacity(get, set):FastFloat;
	public var finalX(get, set):FastFloat;
	public var finalY(get, set):FastFloat;
	public var finalZ(get, set):Int;
	public var finalW(get, set):FastFloat;
	public var finalH(get, set):FastFloat;

	function get_finalOpacity():FastFloat {
		return parent != null ? parent.finalOpacity * opacity : opacity;
	}

	function set_finalOpacity(value:FastFloat):FastFloat {
		return 1.;
	}

	public inline final function get_finalX():FastFloat {
		return parent != null ? parent.get_finalX() + x : x;
	}

	function set_finalX(value:FastFloat):FastFloat {
		return 0.;
	}

	public inline final function get_finalY():FastFloat {
		return parent != null ? parent.get_finalY() + y : y;
	}

	function set_finalY(value:FastFloat):FastFloat {
		return 0.;
	}

	public inline final function get_finalZ():Int {
		return parent != null ? parent.get_finalZ() + z : z;
	}

	function set_finalZ(value:Int):Int {
		return 0;
	}

	public inline final function get_finalW():FastFloat {
		return parent != null ? parent.scaleX * scaleX * width : scaleX * width;
	}

	function set_finalW(value:FastFloat):FastFloat {
		return 0.;
	}

	public inline final function get_finalH():FastFloat {
		return parent != null ? parent.scaleY * scaleY * height : scaleY * height;
	}

	function set_finalH(value:FastFloat):FastFloat {
		return 0.;
	}

	public function new() {
		x = 0.;
		y = 0.;
		z = 0;
		width = 0.;
		height = 0.;
		scaleX = 1.;
		scaleY = 1.;
		rotation = 0.;
		opacity = 1.;
		parent = null;
		children = [];
		visible = true;
		enabled = true;
		clip = false;
	}

	function draw() {}

	public final function drawAll() {
		if (visible) {
			draw();
			for (child in children) {
				child.drawAll();
			}
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
