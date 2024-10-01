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
	public var finalRotation:FastFloat = 0.;
	public var finalOpacity:FastFloat = 1.;
	public var finalEnabled:Bool = true;
	public var finalX:FastFloat = 0.;
	public var finalY:FastFloat = 0.;
	public var finalZ:Int = 0;
	public var finalW:FastFloat = 0.;
	public var finalH:FastFloat = 0.;

	public function draw() {}

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
