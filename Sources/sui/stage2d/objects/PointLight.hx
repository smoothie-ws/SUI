package sui.stage2d.objects;

@:structInit
class PointLight extends Light {
	override inline function castShadows(mesh:MeshObject):Shadows {
		var vertData:Array<Float> = [];
		var indData:Array<Int> = [];

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

				vertData.push(x1);
				vertData.push(y1);
				vertData.push(mesh.opacity);

				vertData.push(x2);
				vertData.push(y2);
				vertData.push(mesh.opacity);

				vertData.push(shadowX1);
				vertData.push(shadowY1);
				vertData.push(mesh.opacity);

				vertData.push(shadowX2);
				vertData.push(shadowY2);
				vertData.push(mesh.opacity);

				indData.push(indOffset);
				indData.push(indOffset + 1);
				indData.push(indOffset + 3);
				indData.push(indOffset + 3);
				indData.push(indOffset + 2);
				indData.push(indOffset);

				indOffset += 4;
			}
		}
		mesh.vertices.unlock();

		var vertices = new VertexBuffer(Std.int(vertData.length / 3), SUIShaders.shadowCaster.structure, StaticUsage);
		var vert = vertices.lock();
		for (i in 0...vertData.length)
			vert[i] = vertData[i];
		vertices.unlock();

		var indices = new IndexBuffer(indData.length, StaticUsage);
		var ind = indices.lock();
		for (i in 0...indData.length)
			ind[i] = indData[i];
		indices.unlock();

		shadowMap.g2.begin(true);
		SUIShaders.shadowCaster.draw(shadowMap, vertices, indices);
		shadowMap.g2.end();
	}
}
