package sui.stage2d.batches;

import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import sui.stage2d.objects.Object;

class ObjectBatch {
	var vertices:VertexBuffer;
	var indices:IndexBuffer;

	var objects:Array<Object> = [];

	public function add(object:Object) {}
}
