package sui.positioning;

enum abstract Direction(Int) from Int to Int {
	// horizontal
	public inline static var LeftToRight:Int = 1;
	public inline static var RightToLeft:Int = 2;

	// vertical
	public inline static var TopToBottom:Int = 4;
	public inline static var BottomToTop:Int = 8;
}
