package sui.core.utils;

inline function capitalizeWords(str:String):String {
	return str.split(" ").map(function(word) {
		return word.charAt(0).toUpperCase() + word.substr(1).toLowerCase();
	}).join(" ");
}
