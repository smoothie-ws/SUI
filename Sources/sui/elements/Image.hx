package sui.elements;

import kha.Assets;
import kha.FastFloat;
// sui
import sui.core.Element;

@:structInit
class Image extends Element {
	public var source:String;

	override function draw() {
		SUI.rawbuffer.g2.drawScaledImage(Assets.images.get(source), offsetX, offsetY, finalW, finalH);
	}
}
