package backend;

import hscript.Parser;
import hscript.Interp;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import Sys;

class HScript
{
    public var parser:Parser;
    public var interp:Interp;
    public var variables:Map<String, Dynamic>;

    public function new()
    {
        parser = new Parser();
        parser.allowTypes = true;
        parser.allowJSON = true;
        parser.allowMetadata = true;

        interp = new Interp();
        variables = new Map();

        setDefaultVariables();
    }

    private function setDefaultVariables()
    {
        // base flixel classez
        set("FlxG", FlxG);
        set("FlxSprite", FlxSprite);
        set("FlxText", FlxText);
        set("FlxColor", FlxColorHScript);

        // ScriptedState lol
        set("ScriptedState", ScriptedState);
        set("FlixelState", FlixelState);
        set("FlixelSubState", FlixelSubState);
        
        // other
        set("Math", Math);
        set("Std", Std);
        set("String", String);
        set("Int", Int);
        set("Float", Float);
        set("Array", Array);
        set("Bool", Bool);        
        set("trace", Sys.println);
    }

    public function set(name:String, val:Dynamic)
    {
        variables.set(name, val);
        interp.variables.set(name, val);
    }

    public function get(name:String):Dynamic
    {
        return variables.get(name);
    }

    public function load(path:String)
    {
        try
        {
            trace('HScript: Attempting to load script: $path');
            if (!Assets.exists(path)) {
                return false;
            }
            
            var script:String = Assets.getText(path);
            
            var program = parser.parseString(script);
            
            interp.execute(program);
            return true;
        }
        catch (e)
        {
            trace('HScript: Error loading script $path: $e');
            trace('HScript: Stack trace: ${e.stack}');
            return false;
        }
    }

    public function call(func:String, ?args:Array<Dynamic>):Dynamic
    {
        if (interp == null) {
            trace('HScript: Interpreter is null when calling $func');
            return null;
        }
        
        if (interp.variables.exists(func))
        {
            var scriptFunc = interp.variables.get(func);
            if (scriptFunc != null && Reflect.isFunction(scriptFunc))
            {
                try
                {
                    return Reflect.callMethod(null, scriptFunc, args == null ? [] : args);
                }
                catch (e)
                {
                    trace('HScript: Error calling $func: $e');
                    trace('HScript: Stack trace: ${e.stack}');
                }
            } else {
                // pee
            }
        } else {
        }
        return null;
    }

    public function destroy()
    {
        if (interp != null)
        {
            interp.variables.clear();
            interp = null;
        }
        
        if (variables != null)
        {
            variables.clear();
            variables = null;
        }
        
        parser = null;
    }
}