package sui.stage2d.lighting;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector3;

@:structInit
class Light {
	public var position:FastVector3 = {};
	public var color:Color = Color.White;
	public var strength:FastFloat = 1;
	public var radius:FastFloat = 0;
	public var isCastingShadows:Bool = true;
}
