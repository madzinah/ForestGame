package ;

class TreeList {

    private var origin(get, null):Tree;
    private var array(default, default):Array<Tree>;
    private var arrayByScale(default, default):Array<Array<Tree>>;


    public function new(t:Tree) {
        this.origin = t;
        this.array = new Array<Tree>();

        var i:Int = origin.get_counter().look_counter();

        for (j in 1...i) {
            this.array.push(searchTree(t, j));
        }

        // Calcul de la profondeur maximale
        var myIt = this.array.iterator();
        var max_height = 0;
        for (j in myIt) {
            max_height = max_height < j.get_scale() ? j.get_scale() : max_height;
        }

        // Création du tableau par hauteur des noeuds, pour la positions des sprites.
        arrayByScale = new Array<Array<Tree>>();
        for (i in 0 ... max_height) {
            arrayByScale[i] = new Array<Tree>();
        }
        for (t in this.array) {
           arrayByScale[t.get_scale() - 1].push(t);
        }

        /* Verif :
        for (j in this.arrayByScale) {
            trace(j.length);
        }
        trace("Elements triés : " + array.length);
        var myIt = array.iterator();
        for (j in myIt) {
            trace(j.get_label());
        }*/
    }

    public function get_origin() {
        return origin;
    }

    public function get_array() {
        return array;
    }

    public function get_arrayByScale() {
        return arrayByScale;
    }

    public function get_x_Scale(label:Int){
        var i:Int = 0;
        for(t in arrayByScale) {
            for (a in t) {
                if (a.get_label() == label) {
                    return i;
                }
                i++;
            }
            i = 0;
        }
        return -1;
    }

    public function get_y_Scale(label:Int){
        var i:Int = 0;
        for(t in arrayByScale) {
            for (a in t) {
                if (a.get_label() == label) {
                    return i;
                }
            }
            i++;
        }
        return -1;
    }

    // Recherche et renvoie le noeud qui correspond au label
    private function searchTree(t:Tree, label:Int) {
        var a:Array<Tree> = new Array<Tree>();
        return recursiveSearch(t, label, a);
    }

    private function recursiveSearch(t:Tree, label:Int, a:Array<Tree>) {
        a.push(t);
        if (t.get_label() == label) {
            return t;
        }
        var myIt = t.get_sons().iterator();
        for (son in myIt) {
            if (a.indexOf(son) == -1) {
                var result = recursiveSearch(son, label, a);
                if (result != null) {
                    return result;
                }
            }
        }
        return null;
    }

    public function isFinished() {
        var b = true;
        for (a in arrayByScale) {
            if (a.length > 1) {
                b = false;
            }
        }
        return b;
    }
}
