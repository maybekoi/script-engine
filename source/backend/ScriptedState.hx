package backend;

import flixel.FlxState;
import flixel.FlxG;

class ScriptedState extends FlixelState
{
    public var script:HScript;
    private var scriptPath:String;

    public function new(?scriptPath:String)
    {
        super();
        this.scriptPath = scriptPath;
    }

    override function create()
    {
        trace("ScriptedState: Creating script");
        script = new HScript();
        
        script.set("script", script);
        script.set("state", this);
        script.set("close", close);
        script.set("switchState", switchState);
        script.set("FlxG", FlxG);
        
        if (scriptPath != null) {
            trace("ScriptedState: Loading script from constructor path");
            loadScript(scriptPath);
        }

        super.create();
        
        trace("ScriptedState: Calling script create()");
        script.call("create");
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        script.call("update", [elapsed]);
    }

    public function loadScript(path:String)
    {
        trace("ScriptedState: Loading script started");
        if (script != null) {
            var success = script.load(path);
            trace('ScriptedState: Loading script ${path}: ${success ? "SUCCESS" : "FAILED"}');
        } else {
            trace("ScriptedState: Script is null!");
        }
    }

    public function close(state:FlxState)
    {
        FlxG.switchState(state);
    }

    override function destroy()
    {
        if (script != null)
            script.destroy();
            
        super.destroy();
    }
}