package sui.core.graphics;

import kha.graphics4.VertexData;
// sui
import sui.core.graphics.Shader2D;

class RectPainter extends Shader2D {
	public function new() {}

	override inline function initStructure() {
		structure.add("vertData", VertexData.Float32_4X);
		structure.add("vertColor", VertexData.Float32_4X);
		structure.add("vertRadius", VertexData.Float1);
	}
}
