var text;
var elapsed_total = 0;

function create() {    
    text = new FlxText(10, 10, 0, "Skibidididi", 16);
    state.add(text);
    
    FlxG.camera.flash();
    
    trace("State created!");
}

function update(elapsed) {
    elapsed_total += elapsed;
    
    if (FlxG.keys.justPressed.ESCAPE) {
        trace("Going to epicState");
        var scriptedState = new ScriptedState("assets/data/states/epicState.hx");
		switchState(scriptedState);
    }
    if (FlxG.keys.justPressed.F1) {
        customFunction(); 
    }
}

function destroy() {
    trace("State destroyed!");
}

function customFunction() {
    trace("This is a custom function!");
}