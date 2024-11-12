package sui.core.graphics.painters;

import kha.Canvas;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
// sui
import sui.elements.Element;

class ElementPainter {
	public var elements:Array<Element> = [];

	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	public function new() {}

	public function draw(target:Canvas) {}
}
