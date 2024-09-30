package sui.elements;

import kha.Color;
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
	// anchors
	public var anchors:Anchors = {};
	// color
	public var color:Color = Color.White;

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

	public function draw() {}

	public inline final function resize() {
		for (child in children)
			child.resize();
	}

	public inline final function render() {
		SUI.graphics.color = color;
		SUI.graphics.opacity = finalOpacity;
		SUI.graphics.pushScale(scaleX, scaleY);
		SUI.graphics.pushRotation(finalRotation, finalX, finalY);
		draw();
		SUI.graphics.popTransformation();
	}

	public function renderTree() {
		if (!visible)
			return;

		render();
		for (child in children)
			child.renderTree();
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
