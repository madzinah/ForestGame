package ;
class DMethod {

    var liste(get, null):Array<Array<Tree>>;
    var parite(get, null):Array<Int>;

    public function new(list:TreeList) {

        liste = new Array<Array<Tree>>();
        liste[0] = new Array<Tree>();
        parite = new Array<Int>();
        var tmpWhite = new Array<Tree>();
        var length = 0;

        for (t in list.get_array()) {
            var b = true;
            for (s in t.get_sons()) {
                if (tmpWhite.indexOf(t) != -1) {
                    b = false;
                }
            }
            if (b) {
                tmpWhite.insert(0, t);
            } else {
                liste[length].insert(0, t);
            }
        }
        parite.insert(0, tmpWhite.length % 2);
        while (liste[length].length > 0) {
            liste[length + 1] = new Array<Tree>();
            tmpWhite = new Array<Tree>();
            for (t in liste[length]) {
                var b = true;
                for (s in t.get_sons()) {
                    if (liste[length + 1].indexOf(s) != -1) {
                        if (tmpWhite.indexOf(t) != -1) {
                            b = false;
                        }
                    }
                }
                if (b) {
                    tmpWhite.insert(0, t);
                } else {
                    liste[length + 1].insert(0, t);
                }
            }

            length++;
            parite.insert(parite.length, tmpWhite.length % 2);
        }
    }


    public function get_liste() {
        return liste;
    }

    public function get_parite() {
        return parite;
    }
}
