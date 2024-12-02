package sui.stage2d.lighting;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector3;

@:structInit
class PointLight {
	public var position:FastVector3;
	public var color:Color;
	public var strength:FastFloat;
	public var radius:FastFloat;
}
