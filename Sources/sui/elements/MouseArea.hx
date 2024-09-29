package sui.elements;

import kha.input.Mouse;

@:structInit
class MouseArea extends Element {
	public var onDown:(button:Int, x:Int, y:Int) -> Void = null;
	public var onUp:(button:Int, x:Int, y:Int) -> Void = null;
	public var onEnter:(x:Int, y:Int) -> Void = null;
	public var onExit:(x:Int, y:Int) -> Void = null;
	public var onMove:(x:Int, y:Int, moveX:Int, moveY:Int) -> Void = null;
	public var onWheel:(delta:Int) -> Void = null;

	public var mouseX:Int = 0;
	public var mouseY:Int = 0;

	var _focused:Bool = false;
	var focused(get, never):Bool;

	function get_focused():Bool {
		final xBounded = mouseX >= finalX && mouseX <= finalX + finalW;
		final yBounded = mouseY >= finalY && mouseY <= finalY + finalH;
		return xBounded && yBounded;
	}

	public inline function startListening() {
		Mouse.get().notify(function(button:Int, x:Int, y:Int) {
			if (focused)
				onDown(button, x, y);
		}, function(button:Int, x:Int, y:Int) {
			if (focused)
				onUp(button, x, y);
		}, function(x:Int, y:Int, moveX:Int, moveY:Int) {
			mouseX = x;
			mouseY = y;

			if (focused && !_focused) {
				if (onEnter != null)
					onEnter(x, y);
			} else if (!focused && _focused) {
				if (onExit != null)
					onExit(x, y);
			}

			_focused = focused;

			if (focused && onMove != null)
				onMove(x, y, moveX, moveY);
		}, function(delta:Int) {
			if (focused && onWheel != null)
				onWheel(delta);
		});
	}
}
