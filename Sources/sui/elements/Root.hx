package sui.elements;

@:structInit
class Root extends Element {
	public inline function update() {
		for (c in children)
			c.scale -= 0.01;
	}

	public inline function resize(w:Int, h:Int) {
		anchors.right.position = w;
		anchors.bottom.position = h;
	}
}
