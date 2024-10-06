package sui.elements.controls;

import kha.FastFloat;

@:structInit
class Control extends Element {
	public var background:Element = {};
	public var content:Element = {};
	public var padding:FastFloat = 0.;

	override function construct() {
		addChild(background);
		addChild(content);
		
		background.anchors.fill = this;
		content.anchors.fill = this;
		content.anchors.margins = padding;
	}
}
