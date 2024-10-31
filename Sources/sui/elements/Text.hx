package sui.elements;

import kha.Assets;
import kha.FastFloat;
// sui
import sui.core.Element;
import sui.core.layouts.Alignment;
import sui.core.utils.String.capitalizeWords;

@:structInit
class Text extends Element {
	public var text:String = "";
	public var alignment:Int = Alignment.HCenter | Alignment.VCenter;
	public var font:Font = {};

	override function draw() {
		var f = Assets.fonts.get(font.family);

		SUI.rawbuffer.g2.font = f;
		SUI.rawbuffer.g2.fontSize = font.size;

		switch (font.capitalization) {
			case Capitalization.MixedCase:
			case Capitalization.AllUppercase:
				text = text.toUpperCase();
			case Capitalization.AllLowercase:
				text = text.toLowerCase();
			case Capitalization.Capitalize:
				text = capitalizeWords(text);
		}

		var lineWidth = font.size / 25;
		var lineHeight = f.height(font.size);
		var lineLength = f.width(font.size, text);

		var xPosition = 0.;
		var yPosition = 0.;

		if (alignment & Alignment.Left != 0)
			xPosition = 0.;
		if (alignment & Alignment.Right != 0)
			xPosition = finalW - lineLength;
		if (alignment & Alignment.HCenter != 0)
			xPosition = (finalW - lineLength) / 2;

		if (alignment & Alignment.Top != 0)
			yPosition = 0.;
		if (alignment & Alignment.Bottom != 0)
			yPosition = finalH - lineHeight;
		if (alignment & Alignment.VCenter != 0)
			yPosition = (finalH - lineHeight) / 2;

		SUI.rawbuffer.g2.drawString(text, xPosition, yPosition);

		if (font.strikeout) {
			var lineYPosition = font.size / 2 + (font.size / 7.5);
			SUI.rawbuffer.g2.drawLine(0., Std.int(lineYPosition), lineLength, Std.int(lineYPosition), lineWidth);
		}
		if (font.underline) {
			var lineYPosition = 0.85 * f.height(font.size);
			SUI.rawbuffer.g2.drawLine(0., lineYPosition, lineLength, lineYPosition, lineWidth);
		}
	}
}

@:structInit
class Font {
	public var bold:Bool = false;
	public var family:String = "Arial";
	public var italic:Bool = false;
	public var letterSpacing:FastFloat = 0.;
	public var size:Int = 14;
	public var styleName:String = "Regular";
	public var strikeout:Bool = false;
	public var underline:Bool = false;
	public var weight:Weight = Weight.Normal;
	public var capitalization:Capitalization = Capitalization.MixedCase;
}

enum Capitalization {
	MixedCase;
	AllUppercase;
	AllLowercase;
	Capitalize;
}

enum Weight {
	Thin;
	Light;
	ExtraLight;
	Normal;
	Medium;
	DemiBold;
	Bold;
	ExtraBold;
	Black;
}
