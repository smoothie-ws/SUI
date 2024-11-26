package sui.elements;

import kha.math.FastVector2;
// sui
import sui.elements.Element;

using sui.core.utils.ArrayExt;

class MouseArea extends Element {
	var downListeners:Array<(button:Int, x:Int, y:Int) -> Void> = [];
	var upListeners:Array<(button:Int, x:Int, y:Int) -> Void> = [];
	var enterListeners:Array<(x:Int, y:Int) -> Void> = [];
	var exitListeners:Array<(x:Int, y:Int) -> Void> = [];
	var moveListeners:Array<(x:Int, y:Int, moveX:Int, moveY:Int) -> Void> = [];
	var wheelListeners:Array<(delta:Int) -> Void> = [];

	public var mouseX:Int = 0;
	public var mouseY:Int = 0;

	var _focused:Bool = false;
	var focused:Bool;

	public function new() {
		super();
		SUI.mouse.notify(null, null, function(x:Int, y:Int, moveX:Int, moveY:Int) {
			mouseX = x;
			mouseY = y;

			var intersections = 0;
			var rayEnd = new FastVector2(1e9, y);

			for (i in 0...4)
				if (intersect({x: x, y: y}, rayEnd, rectBounds[i], rectBounds[(i + 1) % rectBounds.length]))
					intersections++;

			focused = intersections % 2 != 0;
		}, null);
	}

	public inline function notifyOnDown(f:(button:Int, x:Int, y:Int) -> Void) {
		downListeners.push(f);
	}

	public inline function notifyOnUp(f:(button:Int, x:Int, y:Int) -> Void) {
		upListeners.push(f);
	}

	public inline function notifyOnEnter(f:(x:Int, y:Int) -> Void) {
		enterListeners.push(f);
	}

	public inline function notifyOnExit(f:(x:Int, y:Int) -> Void) {
		exitListeners.push(f);
	}

	public inline function notifyOnMove(f:(x:Int, y:Int, moveX:Int, moveY:Int) -> Void) {
		moveListeners.push(f);
	}

	public inline function notifyOnWheel(f:(delta:Int) -> Void) {
		wheelListeners.push(f);
	}

	override public inline function construct() {
		SUI.mouse.notify(function(button:Int, x:Int, y:Int) {
			if (focused)
				for (f in downListeners)
					f(button, x, y);
		}, function(button:Int, x:Int, y:Int) {
			if (focused)
				for (f in upListeners)
					f(button, x, y);
		}, function(x:Int, y:Int, moveX:Int, moveY:Int) {
			mouseX = x;
			mouseY = y;

			if (focused) {
				for (f in moveListeners)
					f(x, y, moveX, moveY);
				if (!_focused)
					for (f in enterListeners)
						f(x, y);
			} else if (!focused && _focused)
				for (f in exitListeners)
					f(x, y);

			_focused = focused;
		}, function(delta:Int) {
			if (focused)
				for (f in wheelListeners)
					f(delta);
		});
	}
}
