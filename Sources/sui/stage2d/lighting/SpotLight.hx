package sui.stage2d.lighting;

import kha.FastFloat;

@:structInit
class SpotLight extends Light {
	public var radius:FastFloat = 1.0;
	public var size:FastFloat = 1.0;
	public var blend:FastFloat = 1.0;
}
