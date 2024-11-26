package sui.fsm;

import sui.fsm.FSMState;

@:keep
class FSMException extends haxe.Exception {}

class FSMController {
	public var currentState:FSMState;
	public var transitions:Map<FSMState, Map<String, FSMState>>;

	public inline function new(initialState:FSMState) {
		currentState = initialState;
		transitions = new Map<FSMState, Map<String, FSMState>>();
	}

	public inline function addTransition(fromState:FSMState, event:String, toState:FSMState):Void {
		if (!transitions.exists(fromState))
			transitions.set(fromState, new Map<String, FSMState>());
		transitions.get(fromState).set(event, toState);
	}

	public inline function triggerEvent(event:String):Void {
		var possibleTransitions = transitions.get(currentState);
		if (possibleTransitions != null && possibleTransitions.exists(event)) {
			currentState = possibleTransitions.get(event);
			currentState.onEnter();
		} else {
			throw new FSMException('Invalid event $event for state ${currentState}');
		}
	}
}
