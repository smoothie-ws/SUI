package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.SUI;
import sui.elements.Element.ElementProperties;

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

@:structInit
class RectangleProperties extends ElementProperties {
	public var radius:FastFloat = 0.;
	public var color:Color = Color.White;
}
