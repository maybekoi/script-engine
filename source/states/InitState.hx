package states;

class InitState extends FlixelState
{
	override public function create()
	{
		var scriptedState = new ScriptedState("assets/data/states/epicState.hx");
		switchState(scriptedState);
		super.create();
	}
}
