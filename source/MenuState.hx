package;


import haxe.Int64;
import flixel.util.FlxSave;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState {

    var group:FlxUIRadioGroup;

    /**
	 * Function that is called up when to state is created to set it up. 
	 */
    override public function create():Void {
        FlxG.mouse.useSystemCursor = true; // Utilisation du curseur de l'OS
        var _btnPlay:FlxButton = new FlxButton(0, 0, "Jouer", clickPlay);
        var spr = new FlxSprite();
        spr.loadGraphic("assets/button.png");
        _btnPlay.loadGraphicFromSprite(spr);
        add(_btnPlay);

        _btnPlay.x = FlxG.width / 2 - _btnPlay.width / 2;
        _btnPlay.y = FlxG.height / 2 - _btnPlay.height / 2;
        var id = new Array<String>();
        id.insert(0, "medium"); id.insert(1, "hard");
        var label = new Array<String>();
        label.insert(0, "Normal"); label.insert(1, "Difficile");
        group = new FlxUIRadioGroup(FlxG.width / 2 - 25, FlxG.height / 2 + 30, id, label);
        add(group);

        var title = new FlxText(0, 0, 280, "Le jeu de la forêt", 22);
        title.x = FlxG.width / 2 - 110;
        title.y = FlxG.height / 2 - 180;
        add(title);


        var _save:FlxSave = new FlxSave();
        _save.bind("ForestGame");
        if (_save.data.difficulty == null) {
            group.selectedIndex = 0;
        } else {
            group.selectedIndex = _save.data.difficulty;
        }
        _save.close();


        super.create();
    }

/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */

    override public function destroy():Void {
        super.destroy();
    }

/**
	 * Function that is called once every frame.
	 */

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    private function clickPlay():Void {
        var _save:FlxSave = new FlxSave();
        _save.bind("ForestGame");
        _save.data.difficulty = group.selectedIndex;
        _save.close();
        FlxG.switchState(new PlayState());
    }
}