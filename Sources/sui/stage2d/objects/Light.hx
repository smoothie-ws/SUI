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
	public var strength:FastFloat = 1;
	public var radius:FastFloat = 0;
	public var isCastingShadows:Bool = true;
	public var shadowMap:Image = null;

	public function castShadows(mesh:MeshObject):Image {
		return shadowMap;
	}
}
