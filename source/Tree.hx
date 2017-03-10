package ;
class Tree {


    @:isVar private var label(get, null):Int;
    @:isVar private var sons(get, set):Array<Tree>;
    @:isVar private var father(get, set):Tree;
    private var counter(get, null):TreeCounter;
    private var scale(get, null):Int;

    public function new(counter:TreeCounter, ?creator:Tree, ?height:Int) {
        this.counter = counter;
        scale = height == null ? 1 : height;
        label = counter.get_counter();
        sons = new Array<Tree>();
        father = creator;
        // trace(label, (label == 1 ? "0" : father.get_label()), scale);
        // Math.random() est non-indexé sur le temps du début du prog.
        var i:Int = scale == 1 ? Std.int(Math.random() * 3) : Math.floor(Math.random() * 3);
        if (scale < 6) {
            for (j in 0...i) {
                sons.insert(j, new Tree(counter, this, scale + 1));
            }
        }
    }


    public function get_label() {
        return label;
    }

    public function get_sons() {
        return sons;
    }

    public function get_father() {
        return father;
    }

    public function get_counter(){
        return counter;
    }

    public function get_scale() {
        return scale;
    }

    public function set_sons(list:Array<Tree>) {
        if (list != null) {
            return this.sons = list;
        }
        return null;
    }

    public function set_father(t:Tree) {
        return father = t;
    }
}
