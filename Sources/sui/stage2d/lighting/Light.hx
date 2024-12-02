package sui.stage2d.lighting;

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

	public function castShadows(mesh:MeshObject) {
		var vert:Array<Float> = [];
		var ind:Array<Int> = [];

		var v = mesh.vertices.lock();
		var indOffset = 0;
		for (i in 0...mesh.vertexCount) {
			var x1 = v[i * mesh.structLength];
			var y1 = v[i * mesh.structLength + 1];
			var x2 = v[((i + 1) % mesh.vertexCount) * mesh.structLength];
			var y2 = v[((i + 1) % mesh.vertexCount) * mesh.structLength + 1];

			var normalX = y2 - y1;
			var normalY = x1 - x2;
			var lightVecX = x - x1;
			var lightVecY = y - y1;

			if (normalX * lightVecX + normalY * lightVecY > 0) {
				var shadowX1 = x1 - lightVecX * 100;
				var shadowY1 = y1 - lightVecY * 100;
				var shadowX2 = x2 - (x - x2) * 100;
				var shadowY2 = y2 - (y - y2) * 100;

				vert.push(x1);
				vert.push(y1);
				vert.push(mesh.opacity);

				vert.push(x2);
				vert.push(y2);
				vert.push(mesh.opacity);

				vert.push(shadowX1);
				vert.push(shadowY1);
				vert.push(mesh.opacity);

				vert.push(shadowX2);
				vert.push(shadowY2);
				vert.push(mesh.opacity);

				ind.push(indOffset);
				ind.push(indOffset + 1);
				ind.push(indOffset + 3);
				ind.push(indOffset + 3);
				ind.push(indOffset + 2);
				ind.push(indOffset);

				indOffset += 4;
			}
		}
		mesh.vertices.unlock();
		return {vertices: vert, indices: ind};
	}
}
