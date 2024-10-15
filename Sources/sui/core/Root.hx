package sui.core;

@:structInit
class Root extends Element {
	public inline function update() {
		for (c in children)
			c.rotation += 1;
	}

	override public inline function resize(w:Int, h:Int) {
		anchors.right.position = w;
		anchors.bottom.position = h;
	}
}
