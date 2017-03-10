package ;
class Core {

    private var inC(get, null):Array<Tree>;
    private var outC(get, null):Array<Tree>;

    public function new(array:Array<Tree>) {
        var a = new Array<Tree>();
        a = array.copy();
        inC = new Array<Tree>();
        outC = new Array<Tree>();
        for (t in a) {
            if (t.get_sons().length == 0) {
                inC.insert(0, t);
            }
        }
        for (t in inC) {
            a.remove(t);
        }
        while (a.length > 0) {
            for (t in inC) {
                var f = t.get_father();
                if (f != null) {
                    outC.insert(0, f);
                    if (inC.indexOf(f) != - 1) {
                        inC.remove(f);
                    }
                    a.remove(f);
                }
            }
            for (t in outC) {
                var f = t.get_father();
                if (f != null) {
                    inC.insert(0, f);
                    a.remove(f);
                }
            }
        }
    }

    public function get_inC() {
        return inC;
    }

    public function get_outC() {
        return outC;
    }


}
