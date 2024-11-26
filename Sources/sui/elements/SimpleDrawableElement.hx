package sui.elements;

import kha.Canvas;

class SimpleDrawableElement extends DrawableElement {
	function simpleDraw(target:Canvas) {}

	override inline function draw(target:Canvas) {
		var o = mapToGlobal(origin);

		target.g2.pushTranslation(-o.x, -o.y);
		target.g2.pushScale(scaleX, scaleY);
		target.g2.pushTranslation(o.x, o.y);
		target.g2.pushRotation(rotation, o.x, o.y);
		target.g2.pushTranslation(translationX, translationY);
		target.g2.pushOpacity(finalOpacity);
		simpleDraw(target);
		target.g2.popOpacity();
		target.g2.popTransformation();
		target.g2.popTransformation();
		target.g2.popTransformation();
		target.g2.popTransformation();
		target.g2.popTransformation();
	}
}
