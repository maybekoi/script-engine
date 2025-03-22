package states;

class PlayState extends FlixelState
{
	override public function create()
	{
		var scriptedState = new ScriptedState("assets/data/states/epicState.hx");
		switchState(scriptedState);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
