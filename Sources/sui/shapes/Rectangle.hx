package sui.shapes;

import kha.Color;
import kha.FastFloat;
// sui
import sui.SUI;

class Rectangle extends Element {
	public var radius:FastFloat;
	public var color:Color;

	override function draw() {
		SUI.graphics.color = color;
		SUI.graphics.opacity = finalOpacity;
		SUI.graphics.fillRect(finalX, finalY, finalW, finalH);
	}
}
