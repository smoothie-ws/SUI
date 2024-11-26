package sui.fsm;

typedef State = {
	public var name:String;
	public var onTrigger:Void->Void;
}
