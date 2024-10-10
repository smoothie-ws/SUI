package sui.core;

// import sui.effects.Effect;
import kha.Scaler;
import kha.System;
import kha.Image;
import kha.FastFloat;
// sui
import sui.Color;
import sui.transform.Transform;
import sui.core.utils.Math.clamp;
import sui.effects.Effect;

@:structInit
class Element {
	public var backbuffer:Image = null;
	public var effects:Array<Effect> = [];

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
	// scale
	public var scale:FastFloat = 1.;
	public var scaleX:FastFloat = Math.NaN;
	public var scaleY:FastFloat = Math.NaN;
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
	// transform
	public var transform:Transform = {};

	// final transform
	var finalOpacity(get, never):FastFloat;
	var finalEnabled(get, never):Bool;
	var finalScaleX(get, never):FastFloat;
	var finalScaleY(get, never):FastFloat;
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

	inline function get_finalScaleX():FastFloat {
		var sX = Math.isNaN(scaleX) ? scale : scaleX;
		return sX * transform.scale.x;
	}

	inline function get_finalScaleY():FastFloat {
		var sY = Math.isNaN(scaleY) ? scale : scaleY;
		return sY * transform.scale.y;
	}

	inline function get_offsetX():FastFloat {
		var itemToFill = anchors.fill;
		var oX = 0.;
		if (itemToFill == null)
			oX = Math.isNaN(anchors.left.position) ? x : anchors.left.position;
		else
			oX = Math.isNaN(anchors.left.position) ? itemToFill.offsetX : anchors.left.position;
		oX += Math.isNaN(anchors.left.margin) ? anchors.margins : anchors.left.margin;
		return oX + transform.translate.x;
	}

	inline function get_offsetY():FastFloat {
		var itemToFill = anchors.fill;
		var oY = 0.;
		if (itemToFill == null)
			oY = Math.isNaN(anchors.top.position) ? y : anchors.top.position;
		else
			oY = Math.isNaN(anchors.top.position) ? itemToFill.offsetY : anchors.top.position;
		oY += Math.isNaN(anchors.top.margin) ? anchors.margins : anchors.top.margin;
		return oY + transform.translate.y;
	}

	inline function get_finalW():FastFloat {
		var itemToFill = anchors.fill;
		var fW = 0.;
		if (itemToFill == null)
			fW = Math.isNaN(anchors.right.position) ? width : anchors.right.position;
		else
			fW = Math.isNaN(anchors.right.position) ? itemToFill.finalW : anchors.right.position;
		fW -= Math.isNaN(anchors.left.margin) ? anchors.margins : anchors.left.margin;
		fW -= Math.isNaN(anchors.right.margin) ? anchors.margins : anchors.right.margin;
		return clamp(fW, minWidth, maxWidth);
	}

	inline function get_finalH():FastFloat {
		var itemToFill = anchors.fill;
		var fH = 0.;
		if (itemToFill == null)
			fH = Math.isNaN(anchors.bottom.position) ? height : anchors.bottom.position;
		else
			fH = Math.isNaN(anchors.bottom.position) ? itemToFill.finalH : anchors.bottom.position;
		fH -= Math.isNaN(anchors.top.margin) ? anchors.margins : anchors.top.margin;
		fH -= Math.isNaN(anchors.bottom.margin) ? anchors.margins : anchors.bottom.margin;
		return clamp(fH, minHeight, maxHeight);
	}

	function construct() {}

	public inline final function constructTree() {
		construct();
		for (child in children)
			child.constructTree();
	}

	public function draw() {}

	public inline function drawTree():Image {
		backbuffer = Image.createRenderTarget(SUI.options.width, SUI.options.height);
		if (!visible)
			return backbuffer;

		final oX = offsetX;
		final oY = offsetY;

		final centerX = oX + finalW / 2;
		final centerY = oY + finalH / 2;

		var cXS = Math.isNaN(transform.scale.origin.x) ? centerX : oX + transform.scale.origin.x;
		var cYS = Math.isNaN(transform.scale.origin.y) ? centerY : oY + transform.scale.origin.y;
		var cXR = Math.isNaN(transform.rotation.origin.x) ? centerX : oX + transform.scale.origin.x;
		var cYR = Math.isNaN(transform.rotation.origin.y) ? centerY : oY + transform.scale.origin.y;

		backbuffer.g2.begin(true, kha.Color.Transparent);
		backbuffer.g2.color = kha.Color.fromValue(color);
		backbuffer.g2.opacity = finalOpacity;
		backbuffer.g2.pushTranslation(oX, oY);
		backbuffer.g2.pushTranslation(-cXS, -cYS);
		backbuffer.g2.pushScale(finalScaleX, finalScaleY);
		backbuffer.g2.pushTranslation(cXS, cYS);
		backbuffer.g2.pushRotation((rotation + transform.rotation.angle) * Math.PI / 180, cXR, cYR);
		draw();
		backbuffer.g2.pushTranslation(-oX, -oY);
		backbuffer.g2.end();

		for (child in children) {
			var childBuffer = child.drawTree();
			for (effect in child.effects)
				effect.apply(backbuffer);

			backbuffer.g2.begin(false);
			Scaler.scale(childBuffer, backbuffer, System.screenRotation);
			backbuffer.g2.end();
		}

		backbuffer.g2.popTransformation();
		backbuffer.g2.popTransformation();
		backbuffer.g2.popTransformation();
		backbuffer.g2.popTransformation();
		backbuffer.g2.popTransformation();
		backbuffer.g2.popTransformation();

		return backbuffer;
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
