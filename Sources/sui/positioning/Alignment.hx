package sui.positioning;

enum abstract Alignment(Int) from Int to Int {
	// horizontal
	public static inline var Left:Int = 1;
	public static inline var Right:Int = 2;
	public static inline var HCenter:Int = 4;

	// vertical
	public static inline var Top:Int = 8;
	public static inline var Bottom:Int = 16;
	public static inline var VCenter:Int = 32;

	public static inline var Center:Int = HCenter | VCenter;
}
