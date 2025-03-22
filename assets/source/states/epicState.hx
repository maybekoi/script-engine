import('flixel.FlxG');
import('flixel.FlxSprite');
import('flixel.text.FlxText');

class EpicState extends ScriptedState {
    var sprite:FlxSprite;
    var text:FlxText;
    var elapsed_total:Float = 0;
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
            var scriptedState = new ScriptedState("source/states/epicStateTwo.hx");
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
}