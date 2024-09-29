package sui;

enum abstract Alignment(Int) from Int to Int {
	// horizontal
	public inline static var Left:Int = 1;
	public inline static var Right:Int = 2;
	public inline static var HCenter:Int = 4;
	public inline static var HJustify:Int = 8;

	// vertical
	public inline static var Top:Int = 16;
	public inline static var Bottom:Int = 32;
	public inline static var VCenter:Int = 64;
	public inline static var VJustify:Int = 128;

	public inline static var Default:Int = 136;
}
