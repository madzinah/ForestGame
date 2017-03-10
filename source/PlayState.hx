package;


import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil.LineStyle;
import openfl.Lib;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

using flixel.util.FlxSpriteUtil;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {


    /**
    * ATTRIBUTES
    **/

    var _playerTurn:Bool;

    var _playerText:FlxText;
    var _IAText:FlxText;

    var circles:Array<Array<FlxSprite>>;
    var list:TreeList;
    var canvas:FlxSprite;

    var _timer:FlxTimer;
    var bool:Bool;

    var difficulty:Int;
    /**
	 * Function that is called up when to state is created to set it up.
	 */
    override public function create():Void {
        super.create();
        FlxG.mouse.useSystemCursor = true; // Utilisation du curseur de l'OS

        // Récupère la difficulté dans le fichier de sauvegarde
        var _save:FlxSave = new FlxSave();
        _save.bind("ForestGame");
        difficulty = _save.data.difficulty;
        _save.close();

        // Le canvas qui va servir à dessiner les branches
        canvas = new FlxSprite();
        canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
        add(canvas);

        // Le bouton retour
        var _btnMenu:FlxButton = new FlxButton(0, 0, "Retour", clickMenu);
        var spr = new FlxSprite();
        spr.loadGraphic("assets/button.png");
        _btnMenu.loadGraphicFromSprite(spr);
        add(_btnMenu);
        _btnMenu.resetSize();

        _btnMenu.setPosition(FlxG.width - _btnMenu.width,
                FlxG.height - _btnMenu.height);


        var arbre:Tree = new Tree(new TreeCounter()); // Création de l'arborescence
        // trace("Nombre d\'éléments dans l'arbre : " + Std.string(arbre.get_counter().look_counter() - 1));
        while (arbre.get_counter().look_counter() == 2) {
            arbre = new Tree(new TreeCounter()); // Création de l'arborescence
            // trace("Nombre d\'éléments dans l'arbre : " + Std.string(arbre.get_counter().look_counter() - 1));
        }
        list = new TreeList(arbre); // la liste qui contient tous les noeuds

        // Dessin des noeuds

        nodesDrawing();

        // Dessin des branches

        verticesDrawing();

        // Les 2 textes en haut à gauche et droite, montrant à qui est le tour
        // On dessine les deux depuis le début, puis on cache celui qui ne sert pas à tour de rôle
        _playerText = new FlxText(0, 0, 60, "J1", 14);
        add(_playerText);

        _IAText = new FlxText(FlxG.width - 60, 0, 60, "IA", 14);
        add(_IAText);

        playerTurn();


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
        super.update();
        if (!_playerTurn && !bool) {
            if (_timer == null) {
                _timer = new FlxTimer(1.0, IAPlaying, 1); // Au bout d'une seconde, l'IA se lance
                bool = true;
            } else {
                _timer.reset();
                bool = true;
            }

        }
    }

    private function clickMenu():Void { // fonction de Callback sur le bouton Menu
        var _save:FlxSave = new FlxSave();
        _save.bind("ForestGame");
        _save.data.difficulty = difficulty;
        _save.close();
        FlxG.switchState(new MenuState());
    }

    private function onMouseDown(sprite:FlxSprite) { // fonction de Callback placé sur chacun des noeuds.

        if (_playerTurn) {

            var n:Tree = lookingSprite(sprite);

            actingOnTree(n);

            if (list.get_array().length == 0) {
                var _txtTitle = new FlxText(20, 0, 0, "Vous Avez Gagné !", 22);
                _txtTitle.alignment = "center";
                _txtTitle.screenCenter(true, true);
                add(_txtTitle);
            } else {

                update();

                IATurn();
            }
        }
    }


    private function verticesDrawing() { // Fonction de dessin des branches, relie les pères et fils via leur centre
        var lineStyle:flixel.util.LineStyle = { thickness: 1, color: FlxColor.WHITE};

        for (i in 0 ... list.get_array().length) {
            var t:Tree = list.get_array()[i];
            var x_t = list.get_y_Scale(t.get_label());
            var y_t = list.get_x_Scale(t.get_label());
            var cs:FlxSprite = circles[x_t][y_t];
            for (s in t.get_sons()) {
                var x_s = list.get_y_Scale(s.get_label());
                var y_s = list.get_x_Scale(s.get_label());
                var ce = circles[x_s][y_s];
                canvas.drawLine(cs.x + 16, cs.y + 16, ce.x + 16, ce.y + 16, lineStyle);
            }
        }
    }

    private function nodesDrawing() { // Fonction de dessin des noeuds
        circles = new Array<Array<FlxSprite>>();
        var heightSep:Float = list.get_arrayByScale().length + 2;
        for (i in 0 ... list.get_arrayByScale().length) {
            circles[i] = new Array<FlxSprite>();
            var widthSep:Float = list.get_arrayByScale()[i].length + 1;
            for (j in 0 ... list.get_arrayByScale()[i].length) {
                circles[i][j] = new FlxSprite();
                circles[i][j].loadGraphic("assets/circle2.png");
                add(circles[i][j]);
                circles[i][j].setPosition((Lib.current.stage.width / (widthSep)) * (j + 1) - 96,
                (Lib.current.stage.height / (heightSep)) * i);
                // circles[i][j].setPosition(j * 50, i * 50); // Ça fonctionne, juste pas beau
                FlxMouseEventManager.add(circles[i][j], onMouseDown, null, null, null);
            }
        }
    }

    private function playerTurn() {
        if (!_playerTurn) {
            _playerTurn = true;
            _playerText.visible = true;
            _IAText.visible = false;
        }
    }

    private function IATurn() {
        if (_playerTurn) {
            _playerTurn = false;
            _playerText.visible = false;
            _IAText.visible = true;
        }
    }

    private function IAPlaying(Timer:FlxTimer) {

        if (difficulty == 0) { // Mode Normal avec méthode exhaustive

            if (list.isFinished()) { // Si il ne reste qu'un coup à donner, le joue.

                var n = list.get_arrayByScale()[list.get_arrayByScale().length - 1][0];
                actingOnTree(n);

            } else {

                var core = new Core(list.get_array());
                var nb = core.get_inC().length;
                nb = Std.random(nb);

                actingOnTree(core.get_inC()[nb]);

            }
        } else { // Mode Difficile avec méthode de Ulehla

            if (list.isFinished()) { // Si il ne reste qu'un coup à donner, le joue.
                // Pas besoin d'effectuer de lourds calculs.
                var n = list.get_arrayByScale()[list.get_arrayByScale().length - 1][0];
                actingOnTree(n);

            } else {

                var method = new DMethod(list);
                var parite = method.get_parite();

                var index = parite.lastIndexOf(1);
                if (index == -1) {
                    index = 0;
                }

                var a = new Array<Tree>();
                a = list.get_array().copy();

                for (t in method.get_liste()[index]) {
                    a.remove(t);
                }

                actingOnTree(a[0]);

            }
        }

        if (list.get_array().length == 0) {
            var _txtTitle = new FlxText(20, 0, 0, "Vous Avez Perdu !", 22);
            _txtTitle.alignment = "center";
            _txtTitle.screenCenter(true, true);
            add(_txtTitle);
        } else {
            playerTurn();
            bool = false;
        }


    }


    private function lookingSprite(sprite:FlxSprite) {
        // Recherche de l'adresse dans le tableau du sprite
        var x = 0, y = 0;
        for (i in 0 ... circles.length) {
            for ( j in 0 ... circles[i].length) {
                if (sprite == circles[i][j]) {
                    x = i;
                    y = j;
                }
            }
        }
        //trace(x + " " + y);

        return list.get_arrayByScale()[x][y];
    }

    private function actingOnTree(n:Tree) {
        if (n == null) {
            n = list.get_array()[0];
        }
        var a:Array<Tree> = new Array<Tree>();
        while (n != null) {
            a.insert(0, n);
            n = n.get_father();
        }

        for (node in a) {
            for (son in node.get_sons()) {
                son.set_father(null);
            }
        }

        var array = list.get_array();
        for (node in a) {
            array.remove(node);
        }



        var array2 = list.get_arrayByScale();

        for (node in a) {
            array2[node.get_scale() - 1].remove(node);
        }

        for (a in circles) {
            for (c in a) {
                c.destroy();
            }
        }


        nodesDrawing();

        // Redessinage des branches
        canvas.fill(FlxColor.TRANSPARENT);
        verticesDrawing();
    }

}