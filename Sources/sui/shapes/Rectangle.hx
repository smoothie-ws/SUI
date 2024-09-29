package sui.shapes;

import sui.Element.ElementProperties;
import kha.Color;
import kha.FastFloat;
// sui
import sui.SUI;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat;
	public var color:Color;

	public function new(properties:RectangleProperties) {
		super(properties);

		radius = properties.radius;
		color = properties.color;
	}

	override function draw() {
		SUI.graphics.color = color;
		SUI.graphics.opacity = finalOpacity;
		SUI.graphics.pushRotation(finalRotation, finalX, finalY);
		SUI.graphics.fillRect(finalX, finalY, finalW, finalH);
		SUI.graphics.popTransformation();
	}
}

class RectangleProperties extends ElementProperties {
	public var radius:FastFloat = 0.;
	public var color:Color = Color.White;
}
