class MainGame {
    var game:FlxGame;
    
    function new() {
        var config = {
            width: 1280,
            height: 720,
            zoom: -1.0,
            framerate: 60,
            skipSplash: false,
            startFullscreen: false,
            title: "Script Engine Game"
        };
        
        Application.current.window.title = config.title;
        
        var startState = new ScriptedState("source/states/epicState.hx");
        
        game = new FlxGame(
            config.width, 
            config.height, 
            startState,
            config.framerate, 
            config.framerate, 
            config.skipSplash, 
            config.startFullscreen
        );
    }
    
    function getGame() {
        return game;
    }
}