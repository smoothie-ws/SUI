package sui.effects;

import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.Image;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.graphics4.ConstantLocation;

class Shadow {
	public static var shader:FragmentShader;
	public static var pipeline:PipelineState;

	public var size:FastFloat;
	public var quality:Int;

	static var innerID:ConstantLocation = null;
	static var sizeID:ConstantLocation = null;
	static var xID:ConstantLocation = null;
	static var yID:ConstantLocation = null;
	static var qualityID:ConstantLocation = null;
	static var resolutionID:ConstantLocation = null;

	public function new(?size:Float = 8., ?quality:Int = 2) {
		this.size = size;
		this.quality = quality;
	}

	public static function getUniforms() {
		innerID = Blur.pipeline.getConstantLocation("inner");
		sizeID = Blur.pipeline.getConstantLocation("size");
		qualityID = Blur.pipeline.getConstantLocation("quality");
		resolutionID = Blur.pipeline.getConstantLocation("resolution");
	}

	public function apply(buffer:Image) {
		buffer.g2.pipeline = Blur.pipeline;
		buffer.g4.setPipeline(pipeline);

		buffer.g4.setInt(qualityID, quality);
		buffer.g4.setFloat(sizeID, size);
		buffer.g4.setVector2(resolutionID, new FastVector2(512., 512.));
	}
}
