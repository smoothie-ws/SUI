package sui.elements;

import sui.elements.Element;

@:structInit
class MouseArea extends Element {
	var onDown:(button:Int, x:Int, y:Int) -> Void = function(button:Int, x:Int, y:Int) {};
	var onUp:(button:Int, x:Int, y:Int) -> Void = function(button:Int, x:Int, y:Int) {};
	var onEnter:(x:Int, y:Int) -> Void = function(x:Int, y:Int) {};
	var onExit:(x:Int, y:Int) -> Void = function(x:Int, y:Int) {};
	var onMove:(x:Int, y:Int, moveX:Int, moveY:Int) -> Void = function(x:Int, y:Int, moveX:Int, moveY:Int) {};
	var onWheel:(delta:Int) -> Void = function(delta:Int) {};

	public var mouseX:Int = 0;
	public var mouseY:Int = 0;

	var _focused:Bool = false;
	var focused(get, never):Bool;

	function get_focused():Bool {
		final xBounded = mouseX >= finalX && mouseX <= finalX + finalW;
		final yBounded = mouseY >= finalY && mouseY <= finalY + finalH;
		return xBounded && yBounded;
	}

	public inline function notifyOnDown(f:(button:Int, x:Int, y:Int) -> Void) {
		onDown = f;
	}

	public inline function notifyOnUp(f:(button:Int, x:Int, y:Int) -> Void) {
		onUp = f;
	}

	public inline function notifyOnEnter(f:(x:Int, y:Int) -> Void) {
		onEnter = f;
	}

	public inline function notifyOnExit(f:(x:Int, y:Int) -> Void) {
		onExit = f;
	}

	public inline function notifyOnMove(f:(x:Int, y:Int, moveX:Int, moveY:Int) -> Void) {
		onMove = f;
	}

	public inline function notifyOnWheel(f:(delta:Int) -> Void) {
		onWheel = f;
	}

	override public inline function construct() {
		SUI.mouse.notify(function(button:Int, x:Int, y:Int) {
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
