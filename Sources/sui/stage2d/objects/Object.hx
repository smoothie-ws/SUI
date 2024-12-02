package sui.stage2d.objects;

import kha.math.FastVector3;

@:structInit
@:autoBuild(sui.core.macro.SUIMacro.build())
class Object {
	public function new() {}

	public var position:FastVector3 = {};

	public var parent:Object = null;
	public var children:Array<Object> = [];

	public function addChild(child:Object) {
		children.push(child);
		child.parent = this;
	}

	public function removeChild(child:Object) {
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

	public function setParent(parent:Object) {
		parent.addChild(this);
	}

	public function removeParent() {
		parent.removeChild(this);
	}
}
