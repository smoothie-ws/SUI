package sui.elements.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.SUI;

@:structInit
class Rectangle extends Element {
	public var radius:FastFloat = 0.;
	public var color:Color = Color.White;

	override function draw() {
		applyTransformation();
		SUI.graphics.color = color;
		SUI.graphics.fillRect(finalX, finalY, width, height);
		popTransformation();
	}
}
