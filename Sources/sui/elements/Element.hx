package sui.elements;

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

	// final transform
	public var finalRotation(get, never):FastFloat;
	public var finalOpacity(get, never):FastFloat;
	public var finalEnabled(get, never):Bool;
	public var finalX(get, never):FastFloat;
	public var finalY(get, never):FastFloat;
	public var finalW(get, never):FastFloat;
	public var finalH(get, never):FastFloat;
	public var finalScaleX(get, never):FastFloat;
	public var finalScaleY(get, never):FastFloat;

	inline function get_finalRotation():FastFloat {
		return parent == null ? rotation : parent.finalRotation + rotation;
	}

	inline function get_finalOpacity():FastFloat {
		return parent == null ? opacity : parent.finalOpacity * opacity;
	}

	inline function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	inline function get_finalX():FastFloat {
		var baseX = anchors.left.position + anchors.left.padding + x;

		baseX += anchors.left.margin != null ? anchors.left.margin : anchors.margins;
		return baseX;
	}

	inline function get_finalY():FastFloat {
		var baseY = anchors.top.position + anchors.top.padding + y;

		baseY += anchors.top.margin != null ? anchors.top.margin : anchors.margins;
		return baseY;
	}

	inline function get_finalW():FastFloat {
		var baseW = anchors.right.position - anchors.right.padding + width;

		baseW -= anchors.right.margin != null ? anchors.right.margin : anchors.margins;
		return baseW;
	}

	inline function get_finalH():FastFloat {
		var baseH = anchors.bottom.position - anchors.bottom.padding + height;

		baseH -= anchors.bottom.margin != null ? anchors.bottom.margin : anchors.margins;
		return baseH;
	}

	inline function get_finalScaleX():FastFloat {
		return parent == null ? scaleX : parent.finalScaleX * scaleX;
	}

	inline function get_finalScaleY():FastFloat {
		return parent == null ? scaleY : parent.finalScaleY * scaleY;
	}

	public function draw() {}

	public inline final function render() {
		SUI.graphics.color = kha.Color.fromValue(color);
		SUI.graphics.opacity = finalOpacity;
		SUI.graphics.pushScale(finalScaleX, finalScaleY);
		SUI.graphics.pushRotation(finalRotation, 0, 0);
		SUI.graphics.translate(finalX, finalY);
		draw();
		SUI.graphics.translate(-finalX, -finalY);
		SUI.graphics.popTransformation();
	}

	public function drawTree() {
		if (!visible)
			return;

		render();
		for (child in children)
			child.drawTree();
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
