package sui.core.graphics;

import sui.core.graphics.shaders.deferred.GeometryPass;
import sui.core.graphics.shaders.deferred.LightingPass;

class DeferredRenderer {
	static public var geometry:GeometryPass = new GeometryPass();
	static public var lighting:LightingPass = new LightingPass();
}
