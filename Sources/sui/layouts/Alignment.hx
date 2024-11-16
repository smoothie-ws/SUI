package sui.layouts;

enum abstract Alignment(Int) from Int to Int {
	// horizontal
	public inline static var Left:Int = 1;
	public inline static var Right:Int = 2;
	public inline static var HCenter:Int = 4;

	// vertical
	public inline static var Top:Int = 8;
	public inline static var Bottom:Int = 16;
	public inline static var VCenter:Int = 32;
}
