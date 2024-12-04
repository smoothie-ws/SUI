package sui.stage2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
// sui
import sui.stage2d.objects.Object;
import sui.stage2d.objects.MeshObject;

@:structInit
class Light extends Object {
	public var color:Color = Color.White;
	public var power:FastFloat = 1;
	public var radius:FastFloat = 0;
	public var isCastingShadows:Bool = true;

	public function new(?color:Color = Color.White, ?power:FastFloat = 1, ?radius:FastFloat = 0, ?isCastingShadows:Bool = true) {
		super();
		
		this.color = color;
		this.power = power;
		this.radius = radius;
		this.isCastingShadows = isCastingShadows;
	}

	public function drawShadows(target:Image, meshes:Array<MeshObject>):Void {}
}
