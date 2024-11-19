package sui.elements.batches;

import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;

class ElementBatch extends DrawableElement {
	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	public inline function add(element:Element) {
		element.instanceID = children.length;
		element.batch = this;
		children.push(element);
	};
}
