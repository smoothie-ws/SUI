package sui.elements.batches;

import sui.elements.Element;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;

@:allow(sui.elements.Element)
class ElementBatch extends DrawableElement {
	public var indices:IndexBuffer;

	var vertices:VertexBuffer;

	function add(element:Element) {}

	override inline function addChild(element:Element) {
		element.instanceID = children.length;
		element.batch = this;
		children.push(element);
		add(element);
	};
}
