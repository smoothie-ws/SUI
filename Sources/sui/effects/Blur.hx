package sui.effects;

import kha.Image;
import kha.Shaders;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.graphics4.ConstantLocation;

class Blur extends Effect {
	public var size:FastFloat;
	public var quality:Int;

	var sizeID:ConstantLocation = null;
	var qualityID:ConstantLocation = null;
	var resolutionID:ConstantLocation = null;

	public function new(?size:Float = 8., ?quality:Int = 2) {
		super();

		this.size = size;
		this.quality = quality;
	}

	override function getUniforms() {
		sizeID = pipeline.getConstantLocation("size");
		qualityID = pipeline.getConstantLocation("quality");
		resolutionID = pipeline.getConstantLocation("resolution");
	}

	override function setUniforms(buffer:Image) {
		buffer.g4.setInt(qualityID, quality);
		buffer.g4.setFloat(sizeID, size);
		buffer.g4.setVector2(resolutionID, new FastVector2(512., 512.));
	}
}
