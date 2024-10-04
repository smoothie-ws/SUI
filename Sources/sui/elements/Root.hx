package sui.elements;

@:structInit
class Root extends Element {
	public inline function update() {
		for (c in children)
			c.color.B -= 1;
	}

	public inline function resize(w:Int, h:Int) {
		anchors.right.position = w;
		anchors.bottom.position = h;
	}
}
