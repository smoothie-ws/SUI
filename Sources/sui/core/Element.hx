package sui.core;

import kha.System;
import kha.Scaler;
import kha.Canvas;
import kha.Image;
import kha.FastFloat;
// sui
import sui.Color;
import sui.transform.Transform;
import sui.core.utils.Math.clamp;
import sui.effects.Effect;
import sui.core.shaders.EffectShaders;
import sui.core.layouts.Anchors;

@:structInit
class Element {
	public var backbuffer:Image = null;
	public var effects:Array<Effect> = [];

	var needsUpdate:Bool = true;

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
	// border
	public var border:Border = {};

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
		backbuffer = Image.createRenderTarget(SUI.options.width, SUI.options.height);
		for (child in children)
			child.constructTree();
	}

	function resize(w:Int, h:Int) {}

	public inline final function resizeTree(w:Int, h:Int) {
		resize(w, h);
		for (child in children)
			child.resizeTree(w, h);

		needsUpdate = true;
		backbuffer = Image.createRenderTarget(SUI.options.width, SUI.options.height);
	}

	public function draw() {}

	public function renderToTarget(target:Canvas, ?clear:Bool = false, ?clearColor:Color = Color.white) {
		drawTree();

		for (effect in effects)
			effect.apply(target);

		var oX = offsetX;
		var oY = offsetY;

		var centerX = oX + finalW / 2;
		var centerY = oY + finalH / 2;

		var sOX = transform.scale.origin.x;
		var sOY = transform.scale.origin.y;
		var rOX = transform.scale.origin.x;
		var rOY = transform.scale.origin.y;
		var rA = transform.rotation.angle;

		var cXS = Math.isNaN(sOX) ? centerX : oX + sOX;
		var cYS = Math.isNaN(sOY) ? centerY : oY + sOY;
		var cXR = Math.isNaN(rOX) ? centerX : oX + rOX;
		var cYR = Math.isNaN(rOY) ? centerY : oY + rOY;
		var fR = (rotation + rA) * Math.PI / 180;

		target.g2.begin(clear, kha.Color.fromValue(clearColor));
		target.g2.pushTranslation(-cXS, -cYS);
		target.g2.pushScale(finalScaleX, finalScaleY);
		target.g2.pushTranslation(cXS, cYS);
		target.g2.pushRotation(fR, cXR, cYR);
		target.g2.opacity = opacity;
		target.g2.drawImage(backbuffer, 0, 0);
		target.g2.end();

		target.g2.popTransformation(); // rotation
		target.g2.popTransformation(); // translation
		target.g2.popTransformation(); // scale
		target.g2.popTransformation(); // translation

		EffectShaders.clearEffects(target);
	}

	public function drawTree():Void {
		if (!visible) {
			backbuffer.g2.clear(kha.Color.Transparent);
			return;
		}

		if (needsUpdate) {
			backbuffer.g2.begin(false);
			backbuffer.g2.clear(kha.Color.Transparent);
			draw();
			backbuffer.g2.end();

			for (child in children)
				child.renderToTarget(backbuffer);
		}

		needsUpdate = false;
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

@:structInit
class Border {
	public var width:Int = 0;
	public var color:Color = "black";
	public var opacity:Float = 1.0;
}
