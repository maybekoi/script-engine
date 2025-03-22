import('flixel.FlxSprite');
import('flixel.text.FlxText');

class EpicStateTwo extends ScriptedState {
    var text:FlxText;
    var elapsed_total:Float = 0;

    function create() {
        text = new FlxText(10, 10, 0, "Epic State Two!", 16);
        state.add(text);
        
        FlxG.camera.flash();
        
        trace("State Two created!");
    }

    function update(elapsed) {
        elapsed_total += elapsed;
        
        if (FlxG.keys.justPressed.ESCAPE) {
            var scriptedState = new ScriptedState("source/states/epicState.hx");
            switchState(scriptedState);
        }
        if (FlxG.keys.justPressed.F1) {
            customFunction(); 
        }
    }

    function destroy() {
        trace("State Two destroyed!");
    }

    function customFunction() {
        trace("This is a custom function!");
    }
}