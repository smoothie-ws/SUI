package sui.elements.shapes;

import kha.deprecated.Painter;
import kha.FastFloat;
// sui
import sui.core.Element;
import sui.core.graphics.Painters;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;
	public var topLeftRadius:FastFloat = Math.NaN;
	public var topRightRadius:FastFloat = Math.NaN;
	public var bottomLeftRadius:FastFloat = Math.NaN;
	public var bottomRightRadius:FastFloat = Math.NaN;

	override function draw() {
		// [x, y, fragX, fragY, R, G, B, A, radius]
		var dims = [offsetX, offsetY, finalW, finalH];
		Painters.Rect.vertData = [
			[
				dims[0],
				dims[1],
				0,
				0,
				color.R,
				color.G,
				color.B,
				color.A,
				Math.isNaN(topLeftRadius) ? radius : topLeftRadius
			],
			[
				dims[0] + dims[2],
				dims[1],
				1,
				0,
				color.R,
				color.G,
				color.B,
				color.A,
				Math.isNaN(topRightRadius) ? radius : topRightRadius
			],
			[
				dims[0] + dims[2],
				dims[1] + dims[3],
				1,
				1,
				color.R,
				color.G,
				color.B,
				color.A,
				Math.isNaN(bottomLeftRadius) ? radius : bottomLeftRadius
			],
			[
				dims[0],
				dims[1] + dims[3],
				0,
				1,
				color.R,
				color.G,
				color.B,
				color.A,
				Math.isNaN(bottomRightRadius) ? radius : bottomRightRadius
			]
		];

		var angle = rotation * Math.PI / 180;
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);

		var cx = transform.rotation.origin.x;
		cx = Math.isNaN(cx) ? (dims[0] + dims[2]) / 2 : cx;
		var cy = transform.rotation.origin.y;
		cy = Math.isNaN(cy) ? (dims[1] + dims[3]) / 2 : cy;

		for (vert in Painters.Rect.vertData) {
			vert[0] = ((vert[0] - cx) * cos - (vert[1] - cy) * sin) + cx;
			vert[0] /= SUI.options.width;
			vert[1] = ((vert[0] - cx) * sin + (vert[1] - cy) * cos) + cy;
			vert[1] /= SUI.options.height;
			vert[8] /= Math.max(finalW, finalH);
			vert[8] += 0.0001;
		}

		Painters.Rect.apply(SUI.rawbuffer);
	}
}
