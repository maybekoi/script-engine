var sprite;
var text;
var elapsed_total = 0;

function create() {    
    sprite = new FlxSprite(100, 100);
    sprite.makeGraphic(50, 50, 0xFFFF0000);
    state.add(sprite);
    
    text = new FlxText(10, 10, 0, "Scripted State!", 16);
    state.add(text);
    
    FlxG.camera.flash();
    
    trace("State created!");
}

function update(elapsed) {
    elapsed_total += elapsed;
    
    sprite.x = 100 + Math.cos(elapsed_total) * 100;
    sprite.y = 100 + Math.sin(elapsed_total) * 100;
    
    if (FlxG.keys.justPressed.ENTER) {
        trace("Going to epicStateTwo");
        var scriptedState = new ScriptedState("assets/data/states/epicStateTwo.hx");
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