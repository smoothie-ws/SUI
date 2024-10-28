package sui.elements;

import kha.Canvas;
// sui
import sui.core.Element;
import sui.filters.Filter;

@:structInit
class Layer extends Element {
	// filters
	public var filters:Array<Filter> = [];
	public var backdropFilters:Array<Filter> = [];

	override inline public function drawTree(buffer:Canvas):Void {
		if (!visible)
			return;

		for (child in children)
			child.drawTree(SUI.rawbuffers[0]);

		var oX = offsetX;
		var oY = offsetY;

		var centerX = oX + finalW / 2;
		var centerY = oY + finalH / 2;

		var sOX = transform.scale.origin.x;
		var sOY = transform.scale.origin.y;
		var rOX = transform.scale.origin.x;
		var rOY = transform.scale.origin.y;
		var rA = transform.rotation.angle;

		var cXS = Math.isNaN(sOX) ? centerX : oX + sOX;
		var cYS = Math.isNaN(sOY) ? centerY : oY + sOY;
		var cXR = Math.isNaN(rOX) ? centerX : oX + rOX;
		var cYR = Math.isNaN(rOY) ? centerY : oY + rOY;
		var fR = (rotation + rA) * Math.PI / 180;

		// apply element filters
		var sourceBufInd = 0;
		var targetBufInd = 0;
		for (i in 0...filters.length) {
			sourceBufInd = i % 2;
			targetBufInd = (i + 1) % 2;
			SUI.rawbuffers[targetBufInd].g2.begin(true, kha.Color.Transparent);
			filters[i].apply(SUI.rawbuffers[sourceBufInd], SUI.rawbuffers[targetBufInd]);
			SUI.rawbuffers[targetBufInd].g2.end();
		}

		// apply element transformation
		sourceBufInd = (targetBufInd + 1) % 2;
		SUI.rawbuffers[sourceBufInd].g2.begin(true, kha.Color.Transparent);
		SUI.rawbuffers[sourceBufInd].g2.pushTranslation(-cXS, -cYS);
		SUI.rawbuffers[sourceBufInd].g2.pushScale(finalScaleX, finalScaleY);
		SUI.rawbuffers[sourceBufInd].g2.pushTranslation(cXS, cYS);
		SUI.rawbuffers[sourceBufInd].g2.pushRotation(fR, cXR, cYR);
		SUI.rawbuffers[sourceBufInd].g2.pushOpacity(finalOpacity);

		SUI.rawbuffers[sourceBufInd].g2.drawImage(SUI.rawbuffers[targetBufInd], 0, 0);

		SUI.rawbuffers[sourceBufInd].g2.popOpacity(); // opacity
		SUI.rawbuffers[sourceBufInd].g2.popTransformation(); // rotation
		SUI.rawbuffers[sourceBufInd].g2.popTransformation(); // translation
		SUI.rawbuffers[sourceBufInd].g2.popTransformation(); // scale
		SUI.rawbuffers[sourceBufInd].g2.popTransformation(); // translation
		SUI.rawbuffers[sourceBufInd].g2.end();

		// apply element backdrop filters
		var bd_filters = backdropFilters;
		// copy backbuffer
		SUI.rawbuffers[2].g2.begin(true);
		SUI.rawbuffers[2].g2.drawImage(SUI.backbuffer, 0, 0);
		SUI.rawbuffers[2].g2.end();

		var bd_sourceBufInd = 0;
		var bd_targetBufInd = 0;
		for (i in 0...bd_filters.length) {
			bd_sourceBufInd = 2 + i % 2;
			bd_targetBufInd = 2 + (i + 1) % 2;
			SUI.rawbuffers[bd_targetBufInd].g2.begin(true);
			bd_filters[i].apply(SUI.rawbuffers[bd_sourceBufInd], SUI.rawbuffers[bd_targetBufInd], SUI.rawbuffers[sourceBufInd]);
			SUI.rawbuffers[bd_targetBufInd].g2.end();
		}

		// draw element on the buffer
		buffer.g2.begin(false);
		buffer.g2.drawImage(SUI.rawbuffers[bd_targetBufInd], 0, 0);
		buffer.g2.drawImage(SUI.rawbuffers[sourceBufInd], 0, 0);
		buffer.g2.end();
	}
}
