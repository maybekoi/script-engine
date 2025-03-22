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
import lime.app.Application;
using StringTools;

class CustomParser extends Parser {
    public function new() {
        super();
        this.allowTypes = true;
        this.allowJSON = true;
        this.allowMetadata = true;
    }

    override function parseStructure(id:String):Null<hscript.Expr> {
        if (id == "import") {
            ensure(TPOpen);
            
            var tk = token();
            var importPath = "";
            switch(tk) {
                case TConst(CString(s)): importPath = s;
                case _: unexpected(tk);
            }
            
            ensure(TPClose);
            
            return ECall(
                EField(EIdent("script"), "registerImport"),
                [EConst(CString(importPath))]
            );
        }
        if (id == "class") {
            var name = token();
            switch(name) {
                case TId(n):
                case _: unexpected(name);
            }
            
            var extend = null;
            var tk = token();
            switch(tk) {
                case TId("extends"):
                    tk = token();
                    switch(tk) {
                        case TId(n): extend = n;
                        case _: unexpected(tk);
                    }
                case _: 
                    push(tk);
            }
            
            ensure(TBrOpen);
            var fields = [];
            while(true) {
                tk = token();
                if (tk == TBrClose) break;
                push(tk);
                var expr = parseExpr();
                if (expr == null) continue;
                fields.push(expr);
                tk = token();
                if (tk != TSemicolon)
                    push(tk);
            }
            
            return EBlock(fields);
        }
        return super.parseStructure(id);
    }
}

class HScript
{
    public var parser:CustomParser;
    public var interp:Interp;
    public var variables:Map<String, Dynamic>;

    public function new()
    {
        parser = new CustomParser();
        interp = new Interp();
        variables = new Map();

        set("import", function(className:String) {
            final splitClassName:Array<String> = [for (e in className.split('.')) e.trim()];
            final fullClassName:String = splitClassName.join('.');
            final daClass:Class<Dynamic> = Type.resolveClass(fullClassName);
            final daEnum:Enum<Dynamic> = Type.resolveEnum(fullClassName);

            if (daClass == null && daEnum == null) {
                var errorMsg = 'HScript Error: Failed to import "$fullClassName" - Class/Enum not found';
                trace(errorMsg);
                #if sys
                Sys.stderr().writeString(errorMsg + "\n");
                #end
                throw errorMsg;
                return false;
            }
            else {
                if (daEnum != null) {
                    for (constructor in daEnum.getConstructors())
                        Reflect.setField({}, constructor, daEnum.createByName(constructor));
                    set(splitClassName[splitClassName.length - 1], {});
                }
                else {
                    set(splitClassName[splitClassName.length - 1], daClass);
                }
                return true;
            }
        });

        setDefaultVariables();
    }

    private function setDefaultVariables()
    {
        set("FlxG", FlxG);
        set("FlxColor", FlxColorHScript);
        set("ScriptedState", ScriptedState);
        set("FlixelState", FlixelState);
        set("FlixelSubState", FlixelSubState);        
        set("Math", Math);
        set("Std", Std);
        set("String", String);
        set("Int", Int);
        set("Float", Float);
        set("Array", Array);
        set("Bool", Bool);        
        set("trace", Sys.println);
        set("Date", Date);
        set("StringTools", StringTools);
        set("Reflect", Reflect);
        set("Type", Type);
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
            var assetPath = StringTools.replace(path, "assets/", "");
            
            if (!Assets.exists(assetPath)) {
                trace('HScript: Script not found: $assetPath');
                return false;
            }
            
            var script:String = Assets.getText(assetPath);
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
            }
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

    public function registerImport(path:String) {
        var parts = path.split(".");
        var className = parts.pop();
        var packagePath = parts.join(".");
        
        try {
            var cl = Type.resolveClass(path);
            if (cl != null) {
                set(className, cl);
                return true;
            }
        } catch(e) {
            trace('HScript: Error importing $path: $e');
        }
        return false;
    }
}