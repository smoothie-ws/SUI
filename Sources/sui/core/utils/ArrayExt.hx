package sui.core.utils;

class ArrayExt {
	public static inline function last<T>(a:Array<T>):T {
		return a[a.length - 1];
	}

	public static inline function min(a:Array<Float>) {
		var m = a[0];
		for (x in a)
			m = x < m ? x : m;
		return m;
	}
}
