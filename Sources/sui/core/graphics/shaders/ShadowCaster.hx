package sui.core.graphics.shaders;

import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

using kha.graphics2.GraphicsExtension;

class ShadowCaster extends Shader2D {
	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertData", VertexData.Float32_3X);
	}
}
