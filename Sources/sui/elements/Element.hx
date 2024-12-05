package sui.elements;

import kha.FastFloat;
import kha.math.FastVector2;
// sui
import sui.positioning.Anchors;
import sui.elements.batches.ElementBatch;
import sui.core.utils.Math.clamp;

@:autoBuild(sui.core.macro.SUIMacro.build())
class Element {
	public function new(?scene:Scene) {
		anchors = new Anchors(this);
		if (scene != null)
			scene.add(this);
	}

	// anchors
	public var anchors:Anchors;
	@readonly public var left:AnchorLine = {};
	@readonly public var top:AnchorLine = {};
	@readonly public var right:AnchorLine = {};
	@readonly public var bottom:AnchorLine = {};
	@readonly public var horizontalCenter:AnchorLine = {};
	@readonly public var verticalCenter:AnchorLine = {};

	// positioning
	public var x(get, set):FastFloat;
	public var y(get, set):FastFloat;
	public var z:FastFloat;
	public var centerX(get, set):FastFloat;
	public var centerY(get, set):FastFloat;
	public var width(get, set):FastFloat;
	public var height(get, set):FastFloat;
	@:isVar public var minWidth(default, set):FastFloat = Math.NEGATIVE_INFINITY;
	@:isVar public var maxWidth(default, set):FastFloat = Math.POSITIVE_INFINITY;
	@:isVar public var minHeight(default, set):FastFloat = Math.NEGATIVE_INFINITY;
	@:isVar public var maxHeight(default, set):FastFloat = Math.POSITIVE_INFINITY;

	inline function get_x():FastFloat {
		return left.position;
	}

	inline function set_x(value:FastFloat):FastFloat {
		var d = value - x;
		left.position = value;
		horizontalCenter.position += d / 2;
		right.position += d;
		return value;
	}

	inline function get_y():FastFloat {
		return top.position;
	}

	inline function set_y(value:FastFloat):FastFloat {
		var d = value - y;
		top.position = value;
		verticalCenter.position += d / 2;
		bottom.position += d;
		return value;
	}

	inline function get_centerX():FastFloat {
		return horizontalCenter.position;
	}

	inline function set_centerX(value:FastFloat):FastFloat {
		var d = value - centerX;
		left.position += d;
		horizontalCenter.position = value;
		right.position += d;
		return value;
	}

	inline function get_centerY():FastFloat {
		return verticalCenter.position;
	}

	inline function set_centerY(value:FastFloat):FastFloat {
		var d = value - centerY;
		top.position += d;
		verticalCenter.position = value;
		bottom.position += d;
		return value;
	}

	inline function get_width():FastFloat {
		return right.position - x;
	}

	inline function set_width(value:FastFloat):FastFloat {
		value = clamp(value, minWidth, maxWidth);
		horizontalCenter.position = x + value / 2;
		right.position = x + value;
		return value;
	}

	inline function get_height():FastFloat {
		return bottom.position - y;
	}

	inline function set_height(value:FastFloat):FastFloat {
		value = clamp(value, minHeight, maxHeight);
		verticalCenter.position = y + value / 2;
		bottom.position = y + value;
		return value;
	}

	inline function set_minWidth(value:FastFloat):FastFloat {
		minWidth = value;
		width = width;
		return value;
	}

	inline function set_maxWidth(value:FastFloat):FastFloat {
		maxWidth = value;
		width = width;
		return value;
	}

	inline function set_minHeight(value:FastFloat):FastFloat {
		minHeight = value;
		height = height;
		return value;
	}

	inline function set_maxHeight(value:FastFloat):FastFloat {
		maxHeight = value;
		height = height;
		return value;
	}

	// transformation
	public var origin:FastVector2 = {};
	@:isVar public var scaleX(default, set):FastFloat = 1;
	@:isVar public var scaleY(default, set):FastFloat = 1;
	@:isVar public var rotation(default, set):FastFloat = 0;
	@:isVar public var translationX(default, set):FastFloat = 0;
	@:isVar public var translationY(default, set):FastFloat = 0;

	function set_scaleX(value:FastFloat):FastFloat {
		scaleX = value;
		return value;
	}

	function set_scaleY(value:FastFloat):FastFloat {
		scaleY = value;
		return value;
	}

	function set_rotation(value:FastFloat):FastFloat {
		rotation = value;
		return value;
	}

	function set_translationX(value:FastFloat):FastFloat {
		translationX = value;
		return value;
	}

	function set_translationY(value:FastFloat):FastFloat {
		translationY = value;
		return value;
	}

	public inline function scale(?x:FastFloat = 1, ?y:FastFloat = 1) {
		scaleX *= x;
		scaleY *= y;
	}

	public inline function rotate(angle:FastFloat = 0) {
		rotation += angle;
	}

	public inline function translate(?x:FastFloat = 0, ?y:FastFloat = 0) {
		translationX += x;
		translationY += y;
	}

	public var parent:Element = null;
	public var children:Array<Element> = [];
	public var enabled:Bool = true;

	public var finalEnabled(get, never):Bool;

	function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	public var batch:ElementBatch;
	public var instanceID:Int;
	public var batchType(get, never):Class<ElementBatch>;

	function get_batchType():Class<ElementBatch> {
		return null;
	}

	public function resize(w:Int, h:Int) {
		width = w;
		height = h;
	}

	public inline function resizeTree(w:Int, h:Int) {
		resize(w, h);
		for (child in children)
			child.resizeTree(w, h);
	}

	public function addChild(child:Element) {
		children.push(child);
		child.parent = this;
	}

	public function removeChild(child:Element) {
		var index = children.indexOf(child);
		if (index != -1) {
			children.splice(index, 1);
			child.parent = null;
		}
	}

	public function removeChildren() {
		for (child in children)
			child.parent = null;

		children = [];
	}

	public function setParent(parent:Element) {
		parent.addChild(this);
	}

	public function removeParent() {
		parent.removeChild(this);
	}

	public inline function mapFromGlobal(point:FastVector2):FastVector2 {
		return {x: point.x - x, y: point.y - y};
	}

	public inline function mapToGlobal(point:FastVector2):FastVector2 {
		return {x: point.x + x, y: point.y + y};
	}

	public static inline function mapFromElement(element:Element, point:FastVector2):FastVector2 {
		return element.mapToGlobal(point);
	}

	public static inline function mapToElement(element:Element, point:FastVector2):FastVector2 {
		return element.mapFromGlobal(point);
	}
}
