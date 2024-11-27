package sui.stage2d.lighting;

import kha.FastFloat;
import kha.math.FastVector2;
import kha.math.FastVector3;

@:structInit
class Light {
	public var color:FastVector3 = {x: 1.0, y: 1.0, z: 1.0};
	public var position:FastVector2 = {x: 0.0, y: 0.0};
	public var power:FastFloat = 1.0;
}
