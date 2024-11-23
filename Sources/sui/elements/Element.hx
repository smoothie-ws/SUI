package sui.elements;

import kha.FastFloat;
import kha.math.FastVector2;
import kha.arrays.Float32Array;
// sui
import sui.positioning.Anchors;
import sui.elements.batches.ElementBatch;

class Element {
	public var batch:ElementBatch;
	public var instanceID:Int;
	public var batchType(get, never):Class<ElementBatch>;

	function get_batchType():Class<ElementBatch> {
		return null;
	}

	// anchors
	public var anchors:Anchors;

	// dimensions
	public var bounds = new Float32Array(4);
	public var bounds_cache = new Float32Array(8);
	public var x(get, set):FastFloat;
	public var y(get, set):FastFloat;
	public var width(get, set):FastFloat;
	public var height(get, set):FastFloat;

	function get_x():FastFloat {
		return anchors.left.position;
	}

	function set_x(value:FastFloat):FastFloat {
		anchors.left.position = x;
		return value;
	}

	function get_y():FastFloat {
		return anchors.top.position;
	}

	function set_y(value:FastFloat):FastFloat {
		anchors.top.position = y;
		return value;
	}

	function get_width():FastFloat {
		return anchors.right.position - x;
	}

	function set_width(value:FastFloat):FastFloat {
		anchors.right.position = x + value;
		return value;
	}

	function get_height():FastFloat {
		return anchors.bottom.position - y;
	}

	function set_height(value:FastFloat):FastFloat {
		anchors.bottom.position = y + value;
		return value;
	}

	// transformation
	public var origin:FastVector2 = {};
	public var scale:FastVector2 = {x: 1, y: 1};
	public var rotation:FastFloat = 0;
	public var translation:FastVector2 = {};

	public var opacity:FastFloat = 1;
	public var parent:Element = null;
	public var children:Array<Element> = [];
	public var visible:Bool = true;
	public var enabled:Bool = true;

	public var finalEnabled(get, never):Bool;
	public var finalOpacity(get, never):FastFloat;

	function get_finalEnabled():Bool {
		return parent == null ? enabled : parent.finalEnabled && enabled;
	}

	function get_finalOpacity():FastFloat {
		return parent == null ? opacity : parent.finalOpacity * opacity;
	}

	public function new() {
		anchors = new Anchors(this);
	}

	public inline function rebuildBounds() {
		var rotCos = Math.cos(rotation);
		var rotSin = Math.sin(rotation);

		bounds_cache[0] = (bounds[0] - origin.x) * scale.x + origin.x + translation.x;
		bounds_cache[1] = (bounds[1] - origin.y) * scale.y + origin.y + translation.y;

		bounds_cache[2] = (bounds[2] - origin.x) * scale.x + origin.x + translation.x;
		bounds_cache[3] = (bounds[1] - origin.y) * scale.y + origin.y + translation.y;

		bounds_cache[4] = (bounds[2] - origin.x) * scale.x + origin.x + translation.x;
		bounds_cache[5] = (bounds[3] - origin.y) * scale.y + origin.y + translation.y;

		bounds_cache[6] = (bounds[0] - origin.x) * scale.x + origin.x + translation.x;
		bounds_cache[7] = (bounds[3] - origin.y) * scale.y + origin.y + translation.y;
	}

	public function resize(w:Int, h:Int) {
		width = w;
		height = h;
	}

	public function resizeTree(w:Int, h:Int) {
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

	public function construct() {}

	public function constructTree() {
		construct();
		for (child in children)
			child.constructTree();
	}
}
