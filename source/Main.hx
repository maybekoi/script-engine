package;

import flixel.FlxGame;
import openfl.display.Sprite;
import backend.HScript;
import backend.ScriptedState;
import lime.app.Application;

class Main extends Sprite
{
    private var script:HScript;

    public function new()
    {
        super();
        
        script = new HScript();
        
        script.set("Sprite", Sprite);
        script.set("FlxGame", FlxGame);
        script.set("ScriptedState", ScriptedState);
        script.set("Application", Application);
        script.set("this", this);
        
        script.set("script", script);
        
        if (script.load("source/Main.hx")) {
            script.call("new");
            var game = script.call("getGame");
            if (game != null) {
                addChild(game);
            }
        }
    }
}