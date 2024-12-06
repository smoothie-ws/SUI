package sui.core.graphics.shaders;

import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

class ShadowCaster extends Shader2D {
	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_2X);
	}
}
