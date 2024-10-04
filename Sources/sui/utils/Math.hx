package sui.utils;

inline function arrMax(arr:Array<Dynamic>) {
	var max:Dynamic = arr[0];
	for (i in 1...arr.length)
		if (arr[i] > max)
			max = arr[i];
	return max;
}

inline function arrMin(arr:Array<Dynamic>) {
	var min:Dynamic = arr[0];
	for (i in 1...arr.length)
		if (arr[i] < min)
			min = arr[i];
	return min;
}

inline function clamp(x:Dynamic, xmin:Dynamic, xmax:Dynamic) {
	return Math.max(Math.min(x, xmax), xmin);
}
