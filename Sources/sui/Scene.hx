package sui;

class Scene extends Element {
	public function update() {
		for (child in children) {
			child.x += 0.5;
			for (grandchild in child.children) {
				grandchild.rotation += 0.1;
			}
		}
	}
}
